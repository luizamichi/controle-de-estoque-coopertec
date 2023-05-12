# Controle de Estoque

_Tempo previsto de leitura: 7 minutos_

_Tempo previsto de entendimento: 30/60 minutos_

Desenvolva um pequeno banco de dados hipotético para controle de clientes, produtos e pedidos. Não se preocupe com interface ou com o usuário que irá utilizar o sistema.

Queremos ver sua organização e saber se sabe criar objetos básicos do banco de dados Oracle.

Fique à vontade para incluir novas tabelas, colunas ou procedimentos auxiliares para o desenvolvimento do problema. Por favor, inclua comentários para avaliarmos. Os comentários são importantes!

Conforme as orientações mais adiante, demonstre a construção de consultas SQL relacionando as tabelas criadas e crie também um código PL/SQL que realize validações, checagens, controle de transações, capture exceções, faça inserções e atualizações de dados.

O código precisa ser limpo e consistente.

Não é necessário se preocupar com tabelas de usuários, vendedores, comissões, notas fiscais, logs, auditoria, etc. Foque apenas nos objetos descritos.

Siga uma padronização de indentação e padronize nomes de tabelas, colunas, constraints, índices, foreign keys, procedures, packages, functions, exceptions, triggers, views, etc.

Sintaxes legíveis e nomes autoexplicativos, mesmo que abreviados, aceleram o processo de entendimento durante a leitura dos códigos produzidos.

As seguintes tabelas são exigidas:

1. CLIENTE

Tabela para registrar as informações de clientes, são exigidas no mínimo as colunas:
- Chave primária da tabela de cliente;
- Nome do cliente;
- _Caso considere importante incluir alguma outra coluna para algum tipo de controle, por favor, inclua e comente. Não perca tempo incluindo campos como CPF, RG, data de nascimento, sexo, endereço, telefone._

2. PRODUTO

Tabela para registrar as informações de produtos, são exigidas no mínimo as seguintes colunas:
- Chave primária da tabela de produto;
- Nome do produto;
- Status (liberado, bloqueado);
- Valor;
- Quantidade;
- _Caso considere importante incluir alguma outra coluna para algum tipo de controle, por favor, inclua e comente. Não perca tempo incluindo campos como cor, tamanho, marca, modelo, fornecedor._

3. MOV_PRODUTO

Tabela para registro de entrada e saída de produtos no estoque, é a tabela de movimento de produto. Um movimento pode ser do tipo Entrada de Produto ou Saída de Produto. São exigidas no mínimo as seguintes colunas:
- Chave primária da tabela de movimentação de produto;
- Código do produto;
- Campo para indicar se é uma entrada ou saída de mercadoria;
- Quantidade do produto movimentado;
- Valor unitário do produto;
- _Caso considere importante incluir alguma outra coluna para algum tipo de controle, por favor, inclua e comente. Não perca tempo incluindo campos como datas, tributações, descontos, valor líquido, lote, número de série._

4. PEDIDO

Tabela para registrar os pedidos ou orçamentos. São exigidas no mínimo as seguintes colunas:
- Chave primária da tabela de pedidos;
- Código do cliente;
- Valor total do pedido;
- Status do pedido (efetivado, cancelado, pendente).

5. MOV_PEDIDO

Tabela para registrar os produtos que compõem um pedido. Esta tabela é utilizada na efetivação de um pedido. São exigidos os seguintes campos:
- Código do pedido;
- Código do produto;
- Quantidade;
- Valor unitário do produto;
- _Não é necessário outro campo._

A tabela MOV_PRODUTO é movimentada sempre que ocorre uma saída ou entrada de produto. Um pedido pendente ou cancelado não gera movimentos na tabela MOV_PRODUTO.

As tabelas PEDIDO e MOV_PEDIDO são carregadas via importação de dados por arquivos, considerando que elas podem conter dados inconsistentes e incompletos, você irá trabalhar com os registros já gravados nessas tabelas.

Se ficar em dúvida sobre algum item, descreva um julgamento e continue conforme o julgamento realizado.

Mãos na massa.

* Crie um arquivo de script com os comandos DDL para a criação das tabelas relacionadas acima (CLIENTE, PRODUTO, MOV_PRODUTO, PEDIDO, MOV_PEDIDO).
  Exemplo:
  ```
  CREATE TABLE ... (
    COLUNA_1,
    COLUNA_2,
    COLUNA_3,
    ...
  );
  ```

  ```
  ALTER TABLE ... ADD COLUMN COLUNA_4 ...;
  ```

* Crie uma consulta para conciliar se o saldo dos produtos na tabela PRODUTO está correto. O saldo de um produto é a soma de todas as entradas, subtraindo todas as saídas registradas na tabela de movimento do produto MOV_PRODUTO.

* Crie uma consulta para apresentar os clientes e o valor total gasto por cliente.

* Crie uma consulta com os 20 produtos que tiveram mais saídas e a soma total dos valores vendidos desses produtos.

* Desenvolva uma procedure ou package utilizando PL/SQL para efetuar um pedido previamente registrado nas tabelas PEDIDO e MOV_PEDIDO.
  É importante lembrar que as tabelas de PEDIDO e MOV_PEDIDO podem conter dados inconsistentes, pois são carregadas por meio de importação de dados externos e, portanto, precisam ser verificadas antes do processamento.

  A procedure deve receber dois parâmetros de entrada:
    - Código do pedido;
    - Autorização do gerente (sim ou não).

    A procedure deve fornecer uma mensagem de retorno informando se a efetivação do pedido ocorreu corretamente ou não, por exemplo: "Pedido efetuado com sucesso", "Saldo de produto insuficiente", "Status do pedido inválido", entre outros.

    Além disso, a procedure deve implementar as seguintes validações:
    - Controle de transação para evitar que outra pessoa efetue o mesmo pedido ao mesmo tempo;
    - Validação do status do pedido;
    - Um pedido só pode ser efetivado uma única vez;
    - Validação do status dos produtos, onde o gerente pode autorizar a venda de produtos bloqueados;
    - Validação da disponibilidade do estoque antes de efetivar um pedido, onde todos os produtos precisam estar disponíveis em estoque;
    - Geração de movimento de saída de estoque na tabela MOV_PRODUTO, onde todos os produtos são retirados do estoque imediatamente na efetivação de um pedido;
    - Validação do valor do produto para verificar se o valor no pedido confere com o valor do produto, onde o gerente pode autorizar uma divergência de até 10% do valor do produto;
    - Vinculação do código do pedido na tabela de MOV_PRODUTO para rastrear o estoque de produtos que foram movimentados pelo pedido.

_Revisão: 06/10/2022_
