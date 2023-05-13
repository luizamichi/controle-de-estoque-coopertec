-- 1. Consulta de saldo dos produtos
SELECT P.ID_PRODUTO, P.DES_NOME NOME_PRODUTO, P.NUM_QTD QTD_PRODUTO,
       SUM(CASE WHEN MP.FLAG_TIPO = 'E' THEN MP.NUM_QTD ELSE 0 END) -
       SUM(CASE WHEN MP.FLAG_TIPO = 'S' THEN MP.NUM_QTD ELSE 0 END) SALDO_PRODUTO
  FROM TB_PRODUTO P, TB_MOV_PRODUTO MP
 WHERE P.ID_PRODUTO = MP.ID_PRODUTO(+)
 GROUP BY P.ID_PRODUTO, P.DES_NOME, P.NUM_QTD;


-- 2. Consulta de valor total gasto por cliente
SELECT C.ID_CLIENTE, C.DES_NOME NOME_CLIENTE, SUM(P.NUM_VALOR_TOTAL) TOTAL_GASTO
  FROM TB_CLIENTE C, TB_PEDIDO P
 WHERE C.ID_CLIENTE = P.ID_CLIENTE
   AND P.FLAG_STATUS = 'E' -- Somente pedidos efetivados
 GROUP BY C.ID_CLIENTE, C.DES_NOME;


-- 3. Consulta dos 20 produtos mais vendidos
SELECT P.ID_PRODUTO, P.DES_NOME NOME_PRODUTO, SUM(MP.NUM_QTD) QUANTIDADE_VENDIDA,
       SUM(MP.NUM_QTD * MP.NUM_VALOR_UNITARIO) VALOR_TOTAL_VENDIDO
  FROM TB_PRODUTO P, TB_MOV_PRODUTO MP
 WHERE P.ID_PRODUTO = MP.ID_PRODUTO
   AND MP.FLAG_TIPO = 'S'
 GROUP BY P.ID_PRODUTO, P.DES_NOME
 ORDER BY QUANTIDADE_VENDIDA DESC
 FETCH FIRST 20 ROWS ONLY;
