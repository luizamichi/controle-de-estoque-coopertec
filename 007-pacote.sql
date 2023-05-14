CREATE OR REPLACE PACKAGE PKG_PEDIDO AS

  -- Função para efetivar um produto que está pendente
  FUNCTION EFETIVAR(
    P_ID_PEDIDO IN NUMBER,
    P_AUTORIZACAO_GERENTE IN VARCHAR2 DEFAULT 'N' -- Flag de autorização do gerente: [S]im, [N]ão
  ) RETURN VARCHAR2;

  -- Função para cancelar um produto que está pendente/efetivado
  FUNCTION CANCELAR(
    P_ID_PEDIDO IN NUMBER
  ) RETURN VARCHAR2;
END PKG_PEDIDO;
/


CREATE OR REPLACE PACKAGE BODY PKG_PEDIDO AS

  FUNCTION EFETIVAR(
    P_ID_PEDIDO IN NUMBER,
    P_AUTORIZACAO_GERENTE IN VARCHAR2
  ) RETURN VARCHAR2 IS

    V_LOCK NUMBER;
    V_STATUS_PEDIDO CHAR(1);
    V_PEDIDO_EFETUADO NUMBER;
    V_ID_PRODUTO NUMBER;
    V_VALOR_TOTAL_PEDIDO NUMBER := 0.0; -- Valor total do pedido
    V_VALOR_TOTAL_PRODUTO_ESTOQUE NUMBER; -- Valor total do produto em estoque (para validar a divergência)
    V_VALOR_TOTAL_PRODUTO_PEDIDO NUMBER; -- Valor total do produto no pedido (para validar a divergência)
    V_VALOR_DIVERGE BOOLEAN := FALSE;

    -- Exceções personalizadas
    ERR_LOCK_PEDIDO EXCEPTION;
    ERR_STATUS_PEDIDO EXCEPTION;
    ERR_PEDIDO_EFETUADO EXCEPTION;
    ERR_PRODUTO_BLOQUEADO EXCEPTION;
    ERR_PRODUTO_SEM_ESTOQUE EXCEPTION;
    ERR_VALOR_PRODUTO_DIVERGENTE EXCEPTION;

    PRAGMA EXCEPTION_INIT(ERR_LOCK_PEDIDO, -54);
  BEGIN

    -- Controle de transação (para validar se o registro está sendo efetivado/cancelado por outro operador)
    SELECT ID_PEDIDO, FLAG_STATUS
      INTO V_LOCK, V_STATUS_PEDIDO
      FROM TB_PEDIDO
     WHERE ID_PEDIDO = P_ID_PEDIDO
       FOR UPDATE; -- Trava a linha

    -- Valida se já foi realizada a movimentação do produto
    SELECT COUNT(*)
      INTO V_PEDIDO_EFETUADO
      FROM TB_MOV_PRODUTO
     WHERE ID_PEDIDO = P_ID_PEDIDO;

    IF V_PEDIDO_EFETUADO > 0 THEN
      RAISE ERR_PEDIDO_EFETUADO;
    END IF;

    -- Validação do status do pedido
    IF V_STATUS_PEDIDO <> 'P' THEN
      RAISE ERR_STATUS_PEDIDO;
    END IF;

    -- Validação do status dos produtos e autorização do gerente
    FOR R_PRODUTO IN (
      SELECT P.ID_PRODUTO, P.FLAG_STATUS, P.NUM_QTD, P.NUM_VALOR,
             MP.NUM_QTD_PRODUTO, MP.NUM_VALOR_UNITARIO
        FROM TB_PRODUTO P, TB_MOV_PEDIDO MP
       WHERE MP.ID_PEDIDO = P_ID_PEDIDO
         AND P.ID_PRODUTO = MP.ID_PRODUTO
    ) LOOP

      V_ID_PRODUTO := R_PRODUTO.ID_PRODUTO;

      -- Validação do produto bloqueado
      IF R_PRODUTO.FLAG_STATUS = 'B' AND P_AUTORIZACAO_GERENTE = 'N' THEN
        RAISE ERR_PRODUTO_BLOQUEADO;
      END IF;

      -- Validação da disponibilidade do estoque
      IF R_PRODUTO.NUM_QTD <= R_PRODUTO.NUM_QTD_PRODUTO THEN
        RAISE ERR_PRODUTO_SEM_ESTOQUE;
      END IF;

      V_VALOR_TOTAL_PRODUTO_ESTOQUE := R_PRODUTO.NUM_VALOR * R_PRODUTO.NUM_QTD_PRODUTO;
      V_VALOR_TOTAL_PRODUTO_PEDIDO := R_PRODUTO.NUM_VALOR_UNITARIO * R_PRODUTO.NUM_QTD_PRODUTO;

      V_VALOR_DIVERGE := (V_VALOR_TOTAL_PRODUTO_PEDIDO > V_VALOR_TOTAL_PRODUTO_ESTOQUE * 1.1) OR -- 10% acima (110)
                         (V_VALOR_TOTAL_PRODUTO_PEDIDO < V_VALOR_TOTAL_PRODUTO_ESTOQUE * 0.9); -- 10% abaixo (90)

      -- Validação do valor do produto
      IF V_VALOR_TOTAL_PRODUTO_PEDIDO <> V_VALOR_TOTAL_PRODUTO_ESTOQUE THEN
        IF V_VALOR_DIVERGE OR (NOT V_VALOR_DIVERGE AND P_AUTORIZACAO_GERENTE = 'N') THEN
          RAISE ERR_VALOR_PRODUTO_DIVERGENTE;
        END IF;
      END IF;

      V_VALOR_TOTAL_PEDIDO := V_VALOR_TOTAL_PEDIDO + V_VALOR_TOTAL_PRODUTO_PEDIDO;

      -- Salva a movimentação de produto (saída)
      INSERT INTO TB_MOV_PRODUTO (ID_PRODUTO, FLAG_TIPO, NUM_QTD, NUM_VALOR_UNITARIO, ID_PEDIDO)
      VALUES
      (R_PRODUTO.ID_PRODUTO, 'S', R_PRODUTO.NUM_QTD_PRODUTO, R_PRODUTO.NUM_VALOR_UNITARIO, P_ID_PEDIDO);
    END LOOP;

    -- Efetivação do pedido
    UPDATE TB_PEDIDO
       SET FLAG_STATUS = 'E',
           NUM_VALOR_TOTAL = V_VALOR_TOTAL_PEDIDO,
           FLAG_AUT_GERENTE = P_AUTORIZACAO_GERENTE
     WHERE ID_PEDIDO = P_ID_PEDIDO;

    COMMIT;
    RETURN 'Pedido efetivado com sucesso.';

  EXCEPTION
    WHEN ERR_LOCK_PEDIDO THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20001, 'Pedido já está sendo efetivado por outra pessoa.');

    WHEN ERR_STATUS_PEDIDO THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20002, 'Status do pedido inválido.');

    WHEN ERR_PEDIDO_EFETUADO THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20003, 'Pedido já efetivado.');

    WHEN ERR_PRODUTO_BLOQUEADO THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20004, 'Produto ' || V_ID_PRODUTO || ' bloqueado e não autorizado para venda pelo gerente.');

    WHEN ERR_PRODUTO_SEM_ESTOQUE THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20005, 'Produto ' || V_ID_PRODUTO || ' sem disponibilidade de estoque.');

    WHEN ERR_VALOR_PRODUTO_DIVERGENTE THEN
      ROLLBACK;
      IF P_AUTORIZACAO_GERENTE = 'N' THEN
        RAISE_APPLICATION_ERROR(-20006, 'Valor do produto ' || V_ID_PRODUTO || ' diverge do valor do pedido.');
      ELSE
        RAISE_APPLICATION_ERROR(-20006, 'Valor do produto ' || V_ID_PRODUTO || ' diverge mais de 10% do valor no pedido autorizado pelo gerente.');
      END IF;

    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(SQLCODE, 'Pedido não encontrado.');

  END EFETIVAR;


  FUNCTION CANCELAR(
    P_ID_PEDIDO IN NUMBER
  ) RETURN VARCHAR2 IS

    V_REGISTRO TB_PEDIDO%ROWTYPE;
  BEGIN

    -- Controle de transação
    SELECT *
      INTO V_REGISTRO
      FROM TB_PEDIDO
     WHERE ID_PEDIDO = P_ID_PEDIDO
       AND FLAG_STATUS IN ('P', 'E')
       FOR UPDATE NOWAIT; -- Trava a linha

    -- Insere as quantidades dos produtos de volta ao estoque
    FOR R_PRODUTO IN (
      SELECT ID_PRODUTO, NUM_QTD
        FROM TB_MOV_PRODUTO
       WHERE ID_PEDIDO = P_ID_PEDIDO
         AND FLAG_TIPO = 'S'
    ) LOOP

      UPDATE TB_PRODUTO
         SET NUM_QTD = NUM_QTD + R_PRODUTO.NUM_QTD
       WHERE ID_PRODUTO = R_PRODUTO.ID_PRODUTO;
    END LOOP;

    -- Remove as movimentações de produto
    DELETE FROM TB_MOV_PRODUTO
     WHERE ID_PEDIDO = P_ID_PEDIDO
       AND FLAG_TIPO = 'S';

    -- Altera o status do pedido
    UPDATE TB_PEDIDO
       SET FLAG_STATUS = 'C'
     WHERE ID_PEDIDO = P_ID_PEDIDO;

    COMMIT;
    RETURN 'Pedido cancelado com sucesso.';

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20007, 'Não foi possível cancelar o pedido.');

  END CANCELAR;
END PKG_PEDIDO;
/
