-- 1. Adição de campos para controle de criação e atualização de produtos
ALTER TABLE TB_PRODUTO ADD (
  DT_CRIACAO DATE DEFAULT SYSDATE NOT NULL,
  DT_ATUALIZACAO DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON COLUMN TB_PRODUTO.DT_CRIACAO IS 'Data de criação';
COMMENT ON COLUMN TB_PRODUTO.DT_ATUALIZACAO IS 'Data de atualização';


-- 2. Adição de campos para vínculo do pedido (movimentação de saída) e controle da criação de movimentações de produtos
ALTER TABLE TB_MOV_PRODUTO ADD (
  ID_PEDIDO NUMBER,
  DT_MOVIMENTO DATE DEFAULT SYSDATE NOT NULL,

  CONSTRAINT FK_MOV_PRODUTO_PEDIDO FOREIGN KEY (ID_PEDIDO) REFERENCES TB_PEDIDO (ID_PEDIDO)
);

COMMENT ON COLUMN TB_MOV_PRODUTO.ID_PEDIDO IS 'FK - Pedido';
COMMENT ON COLUMN TB_MOV_PRODUTO.DT_MOVIMENTO IS 'Data de criação';


-- 3. Adição de campos para controle de criação e atualização de pedidos, e para controle de autorização pelo gerente
ALTER TABLE TB_PEDIDO ADD (
  FLAG_AUT_GERENTE CHAR(1) DEFAULT 'N' NOT NULL,
  DT_CRIACAO DATE DEFAULT SYSDATE NOT NULL,
  DT_ATUALIZACAO DATE DEFAULT SYSDATE NOT NULL,

  CONSTRAINT CHK_PEDIDO_AUT_GERENTE CHECK (FLAG_AUT_GERENTE IN ('S', 'N'))
);

COMMENT ON COLUMN TB_PEDIDO.FLAG_AUT_GERENTE IS 'Autorizado pelo gerente: [S]im, [N]ão';
COMMENT ON COLUMN TB_PEDIDO.DT_CRIACAO IS 'Data de criação';
COMMENT ON COLUMN TB_PEDIDO.DT_ATUALIZACAO IS 'Data de atualização';
