-- 1. Trigger para gerar automaticamente a chave primária para a tabela de clientes
CREATE OR REPLACE TRIGGER TRG_TB_CLIENTE
BEFORE INSERT ON TB_CLIENTE
FOR EACH ROW
BEGIN
  :NEW.ID_CLIENTE := SEQ_CLIENTE.NEXTVAL;
END;
/


-- 2. Trigger para gerar automaticamente a chave primária para a tabela de produtos
CREATE OR REPLACE TRIGGER TRG_TB_PRODUTO
BEFORE INSERT ON TB_PRODUTO
FOR EACH ROW
BEGIN
  :NEW.ID_PRODUTO := SEQ_PRODUTO.NEXTVAL;
END;
/


-- 3. Trigger para gerar automaticamente a chave primária para a tabela de movimentações de produtos e para atualizar o saldo do produto
CREATE OR REPLACE TRIGGER TRG_TB_MOV_PRODUTO
BEFORE INSERT ON TB_MOV_PRODUTO
FOR EACH ROW
BEGIN
  :NEW.ID_MOV_PRODUTO := SEQ_MOV_PRODUTO.NEXTVAL;

  IF :NEW.FLAG_TIPO = 'E' THEN
    UPDATE TB_PRODUTO
       SET NUM_QTD = NUM_QTD + :NEW.NUM_QTD
     WHERE ID_PRODUTO = :NEW.ID_PRODUTO;

  ELSIF :NEW.FLAG_TIPO = 'S' THEN
    UPDATE TB_PRODUTO
       SET NUM_QTD = NUM_QTD - :NEW.NUM_QTD
     WHERE ID_PRODUTO = :NEW.ID_PRODUTO;
  END IF;
END;
/


-- 4. Trigger para gerar automaticamente a chave primária para a tabela de pedidos
CREATE OR REPLACE TRIGGER TRG_TB_PEDIDO
BEFORE INSERT ON TB_PEDIDO
FOR EACH ROW
BEGIN
  :NEW.ID_PEDIDO := SEQ_PEDIDO.NEXTVAL;
END;
/


-- 5. Trigger para atualizar automaticamente a data de atualização do produto
CREATE OR REPLACE TRIGGER TRG_ATUALIZACAO_PRODUTO
BEFORE UPDATE ON TB_PRODUTO
FOR EACH ROW
BEGIN
  :NEW.DT_ATUALIZACAO := SYSDATE;
END;
/


-- 6. Trigger para atualizar automaticamente a data de atualização do pedido
CREATE OR REPLACE TRIGGER TRG_ATUALIZACAO_PEDIDO
BEFORE UPDATE ON TB_PEDIDO
FOR EACH ROW
BEGIN
  :NEW.DT_ATUALIZACAO := SYSDATE;
END;
/


-- 7. Trigger para atualizar automaticamente o valor total de um pedido
CREATE OR REPLACE TRIGGER TRG_ATUALIZACAO_MOV_PEDIDO
BEFORE UPDATE ON TB_MOV_PEDIDO
FOR EACH ROW
BEGIN
  UPDATE TB_PEDIDO
     SET NUM_VALOR_TOTAL = NUM_VALOR_TOTAL - (:OLD.NUM_QTD_PRODUTO * :OLD.NUM_VALOR_UNITARIO)
                                           + (:NEW.NUM_QTD_PRODUTO * :NEW.NUM_VALOR_UNITARIO)
   WHERE ID_PEDIDO = :NEW.ID_PEDIDO;
END;
/
