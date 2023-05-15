# Instruções de uso

Para utilizar o sistema corretamente, siga as orientações descritas logo abaixo.

Este é um manual de instruções do sistema, que tem como objetivo auxiliar os usuários a utilizarem o sistema corretamente.

Foi utilizado o Oracle Database 19c neste projeto.


##### 1. Introdução

O objetivo do sistema é gerenciar o estoque de produtos e os pedidos realizados pelos clientes. O sistema é composto por diversas tabelas, gatilhos, sequências e funções que garantem a integridade dos dados e o correto funcionamento do sistema.


##### 2. Cadastro de clientes

Para cadastrar um novo cliente no sistema, é necessário inserir apenas o nome na tabela TB_CLIENTE:
- DES_NOME: nome do cliente.


##### 3. Cadastro de produtos

Para cadastrar um novo produto no sistema, é necessário inserir os seguintes dados na tabela TB_PRODUTO:
- DES_NOME: nome do produto;
- FLAG_STATUS: status do produto (L para "liberado" e B para "bloqueado");
- NUM_VALOR: valor unitário do produto;
- NUM_QTD: quantidade disponível em estoque. Recomenda-se cadastrar inicialmente com a quantidade zerada.


##### 4. Cadastro de pedidos

Para cadastrar um novo pedido no sistema, é necessário inserir os seguintes dados na tabela TB_PEDIDO:
- ID_CLIENTE: identificador do cliente que realizou o pedido;
- NUM_VALOR: valor total do pedido;
- FLAG_STATUS: status do pedido (P para "pendente" e E para "efetivado"). Recomenda-se cadastrar inicialmente como "pendente".


##### 5. Efetivação e cancelamento de pedidos

Para efetivar um pedido, é necessário executar a função PKG_PEDIDO.EFETIVAR informando o ID_PEDIDO do pedido que se deseja efetivar. O sistema irá atualizar o status do pedido para "efetivado" e retirar a quantidade de produtos efetivados do estoque. Informar se foi autorizado pelo gerente é opcional.

Para cancelar um pedido, é necessário executar a função PKG_PEDIDO.CANCELAR informando o ID_PEDIDO do pedido que se deseja cancelar. O sistema irá atualizar o status do pedido para "cancelado" e devolver a quantidade de produtos cancelados para o estoque.

**Observação:** A tabela TB_MOV_PRODUTO é utilizada para registrar as movimentações de entrada e saída de produtos no estoque. Sempre que um pedido for efetivado será vinculado o seu ID nessa tabela. Não insira registros nela do tipo "saída".
