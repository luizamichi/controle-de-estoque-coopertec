~~1. Criar um arquivo de script SQL com os comandos DDL para criação de 4 tabelas:~~

~~- Tabela de cliente;~~

~~- Tabela de produto;~~

~~- Tabela de movimentação de produto;~~

~~- Tabela de pedido;~~

~~- Tabela de movimentação de pedido.~~


~~2. Validar se as chaves primárias, chaves estrangeiras, constraints e outros objetos definidos na primeira etapa estão corretos.~~


~~3. Criar as sequences para as chaves primárias das tabelas:~~

~~- Criar as triggers para definir automaticamente o valor após cada inserção de registro.~~


~~4. Validar se as sequences e triggers estão corretas e testar se está gerando os valores corretos.~~


~~5. Validar se os arquivos SQL estão bem documentados:~~

~~- Verificar se os comentários são intuitivos;~~

~~- Verificar se os nomes dos objetos estão padronizados e autoexplicativos.~~


~~6. Inserir alguns dados nas tabelas para verificar se estão íntegras:~~

~~- Atentar em inserir dados consistentes para realização de testes posteriormente.~~


~~7. Criar consultas específicas em SQL:~~

~~- Criar uma consulta para calcular o saldo de cada produto;~~

~~- Criar uma consulta para apresentar o valor total gasto por cada cliente;~~

~~- Criar uma consulta para buscar os 20 produtos mais vendidos e o valor total de todas as vendas;~~


~~8. Certificar se o resultado das consultas SQL feitas anteriormente estão corretos.~~


~~9. Criar uma stored procedure ou uma package para efetivar um pedido:~~

~~- Certificar que a procedure/function receberá como parâmetro o ID do pedido e a flag de gerente:~~

   ~~- Definir se a mensagem será o retorno da função ou um parâmetro OUT.~~

~~- Verificar se o pedido está pendente ou cancelado e lançar uma exceção.~~

~~- Utilizar transação para garantir a consistência dos dados;~~

~~- Verificar se o produto está bloqueado e lançar uma exceção se não for gerente;~~

~~- Verificar se o valor diverge 10% e se é gerente (lançar exceção se preciso);~~

~~- Inserir o ID do pedido na tabela de movimentação quando concluir.~~


~~10. Criar na mesma package uma função para cancelar um pedido:~~

~~- Verificar se está pendente e apenas cancelar;~~

~~- Verificar se está cancelado e lançar uma exceção;~~

~~- Verificar se está efetivado e cancelar:~~

   ~~- Adicionar a quantidade dos produtos que saíram de volta à tabela de produtos;~~

   ~~- Remover o ID do pedido na tabela de movimentações de produtos.~~


~~11. Validar se está tudo correto (nomenclatura, complexidade, etc.) na package criada.~~


~~12. Testar tudo para garantir que está funcionando corretamente e produzindo os resultados esperados:~~

   ~~- Revisar todo o código pela última vez para garantir que esteja limpo, consistente e seguindo as boas práticas de desenvolvimento do Oracle SQL.~~


14. Fazer um manual simples de utilização:

   - Orientar que cadastre a quantidade de produtos zerada no cadastro;

   - Orientar que os pedidos sejam cadastrados com o status "pendente";

   - Orientar que utilizem as funções criadas para cancelamento/efetivação de pedidos;

   - Orientar que não criem registros na tabela de movimentação de produto, pois são gerados automaticamente;
