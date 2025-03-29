# Descrição do Projeto
Este projeto é um exemplo de aplicação com simulação de microserviço, desenvolvido em Delphi 10.1 utilizando o banco de dados Sql Server. Ele segue os padrões orientados a interfaces.

# Funcionalidades Principais
Cadastro de Produtos: O sistema permite o cadastro de produtos, incluindo informações básicas (nome, preço, etc.) e controle de saldo de estoque.

Cadastro de Notas Fiscais: O sistema permite o cadastro de notas fiscais, onde cada nota pode conter vários produtos previamente cadastrados. A nota fiscal possui status (aberto ou fechado) e numeração. O sistema valida o saldo do estoque de cada produto antes de inserir a nota. Caso os produtos estejam disponíveis, o estoque é atualizado automaticamente.

Impressão de Nota Fiscal: Quando uma nota fiscal estiver aberta, ela poderá ser "impressa" e o status da nota fiscal é alterado para fechada. 

Feedback do Processo: O usuário recebe feedback ao final do processamento, seja ele bem-sucedido ou com falhas, para garantir que o sistema esteja funcionando corretamente e fornecer informações claras ao usuário.

Configuração do Ambiente
Delphi 10.1: Certifique-se de ter o Delphi 10.1 instalado no seu ambiente de desenvolvimento.

SQLServer: O projeto utiliza o SQLServer como banco de dados. Certifique-se de possuir o recurso antes da utilização.

Localização do Banco de Dados:

A base de dados está localizada na pasta /db junto ao projeto.
Certifique-se de restaurar o mesmo e se caso for apontar os dados da sua intancia em TDm.
Estrutura do Projeto
/source: Contém o código-fonte do projeto.

/db: Contém o banco de dados SQLite.
