-- @sucesso
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque e liberado
-- Cenário: Efetivar um pedido pendente sem autorização do gerente
-- Quando o usuário efetivar o pedido sem autorização de gerente
-- Então deve retornar a mensagem 'Pedido efetivado com sucesso.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 1 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 1');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 1', 'L', 7.50, 30);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 10, 7.50);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'N');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @sucesso
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E os produtos do pedido estão disponíveis em estoque, liberados e com valores divergentes em menos de 10%
-- Cenário: Efetivar um pedido pendente com autorização do gerente
-- Quando o usuário efetivar o pedido com autorização de gerente
-- Então deve retornar a mensagem 'Pedido efetivado com sucesso.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO_1 NUMBER;
  V_ID_PRODUTO_2 NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 2 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 2');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto 1 Teste 2', 'L', 10.45, 15);

  V_ID_PRODUTO_1 := SEQ_PRODUTO.CURRVAL;

  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto 2 Teste 2', 'L', 5.40, 5);

  V_ID_PRODUTO_2 := SEQ_PRODUTO.CURRVAL;


  DBMS_OUTPUT.PUT_LINE('Produto 1: ' || V_ID_PRODUTO_1);
  DBMS_OUTPUT.PUT_LINE('Produto 2: ' || V_ID_PRODUTO_2);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 60.50, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO_1, 5, 11.00);

  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO_2, 1, 5.50);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'S');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @sucesso
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque e bloqueado
-- Cenário: Efetivar um pedido com um produto bloqueado e com autorização de gerente
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem 'Pedido efetivado com sucesso.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 3 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 3');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 3', 'B', 1.25, 500);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 300, 1.25);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'S');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação cancelado
--           E o produto do pedido está disponível em estoque e liberado
-- Cenário: Efetivar um pedido que está cancelado
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Status do pedido inválido.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 4 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 4');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 4', 'L', 5.00, 5);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'C');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 1, 5.00);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação efetivado
--           E o produto do pedido está disponível em estoque e liberado
--           E foi lançada a movimentação do produto do pedido
-- Cenário: Efetivar um pedido que já foi efetivado
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Pedido já efetivado.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 5 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 5');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 5', 'L', 50.00, 10);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'E');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 3, 50.00);

  INSERT INTO TB_MOV_PRODUTO (ID_PRODUTO, FLAG_TIPO, NUM_QTD, NUM_VALOR_UNITARIO, ID_PEDIDO)
  VALUES
  (V_ID_PRODUTO, 'S', 3, 50.00, V_ID_PEDIDO);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque e bloqueado
-- Cenário: Efetivar um pedido com um produto bloqueado e sem autorização de gerente
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Produto bloqueado e não autorizado para venda pelo gerente.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 6 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 6');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 6', 'B', 5.15, 5);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 3, 5.15);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'N');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido não está disponível em estoque
-- Cenário: Efetivar um pedido com um produto sem estoque
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Produto sem disponibilidade de estoque.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 7 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 7');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 7', 'L', 7.25, 5);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 15, 7.25);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque
-- Cenário: Efetivar um pedido com valor total divergente e sem autorização de gerente
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Valor do produto diverge do valor do pedido.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 8 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 8');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 8', 'L', 5.00, 30);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 10, 4.25);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'N');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @sucesso
-- Funcionalidade: Cancelar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque e liberado
-- Cenário: Cancelar um pedido pendente
-- Quando o usuário cancelar o pedido
-- Então deve retornar a mensagem 'Pedido cancelado com sucesso.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 9 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 9');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 9', 'L', 2.30, 15);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 5, 2.30);


  V_RESULT := PKG_PEDIDO.CANCELAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @sucesso
-- Funcionalidade: Cancelar um pedido
-- Contexto: Dado que existe um pedido na situação efetivado
--           E o produto do pedido está disponível em estoque e liberado
-- Cenário: Cancelar um pedido efetivado
-- Quando o usuário cancelar o pedido
-- Então deve retornar a mensagem 'Pedido cancelado com sucesso.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 10 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 10');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 10', 'L', 2.80, 20);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 10, 2.80);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO);
  V_RESULT := PKG_PEDIDO.CANCELAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Cancelar um pedido
-- Contexto: Dado que existe um pedido na situação cancelado
--           E o produto do pedido está disponível em estoque e liberado
-- Cenário: Cancelar um pedido cancelado
-- Quando o usuário cancelar o pedido
-- Então deve retornar a mensagem 'Não foi possível cancelar o pedido.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 11 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 11');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 11', 'L', 22.40, 200);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'C');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 100, 22.40);


  V_RESULT := PKG_PEDIDO.CANCELAR(V_ID_PEDIDO);
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/


-- @erro
-- Funcionalidade: Efetivar um pedido
-- Contexto: Dado que existe um pedido na situação pendente
--           E o produto do pedido está disponível em estoque
-- Cenário: Efetivar um pedido com valor total divergente (acima/abaixo de 10%) e autorização de gerente
-- Quando o usuário efetivar o pedido
-- Então deve retornar a mensagem de erro 'Valor do produto diverge mais de 10% do valor no pedido autorizado pelo gerente.'
DECLARE
  V_RESULT VARCHAR2(100);
  V_ID_CLIENTE NUMBER;
  V_ID_PEDIDO NUMBER;
  V_ID_PRODUTO NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || '----- TESTE 12 -----');


  INSERT INTO TB_CLIENTE (DES_NOME)
  VALUES
  ('Cliente Teste 12');

  V_ID_CLIENTE := SEQ_CLIENTE.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || V_ID_CLIENTE);


  INSERT INTO TB_PRODUTO (DES_NOME, FLAG_STATUS, NUM_VALOR, NUM_QTD)
  VALUES
  ('Produto Teste 12', 'L', 7.00, 10);

  V_ID_PRODUTO := SEQ_PRODUTO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Produto: ' || V_ID_PRODUTO);


  INSERT INTO TB_PEDIDO (ID_CLIENTE, NUM_VALOR_TOTAL, FLAG_STATUS)
  VALUES
  (V_ID_CLIENTE, 0.0, 'P');

  V_ID_PEDIDO := SEQ_PEDIDO.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ID_PEDIDO);


  INSERT INTO TB_MOV_PEDIDO (ID_PEDIDO, ID_PRODUTO, NUM_QTD_PRODUTO, NUM_VALOR_UNITARIO)
  VALUES
  (V_ID_PEDIDO, V_ID_PRODUTO, 5, 5.00);


  V_RESULT := PKG_PEDIDO.EFETIVAR(V_ID_PEDIDO, 'S');
  DBMS_OUTPUT.PUT_LINE('Sucesso: ' || V_RESULT || CHR(10));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM || CHR(10));
END;
/
