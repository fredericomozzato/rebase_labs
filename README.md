# Desafio Rebase Labs

Frederico Mozzato - mar/2024


### Subindo a aplicação
Para que a aplicação funcione é necessário um banco de dados PostgreSQL com uma base de dados chamada `relabs`.

Rode o comando abaixo para criar o banco pronto para o uso da aplicação:

```
$ docker run -d -p 127.0.0.1:5432:5432 -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pswd -e POSTGRES_DB=relabs postgres
```

Este comando irá subir um container com a versão mais recente da imagem PostgreSQL, criar um usuário e uma base de dados. A porta padrão do servidor PostgreSQL será mapeada para a porta do container (5432).

Para conectar ao banco pode-se usar esta mesma porta.

### Importar dados CSV
Para fazer o import dos dados do arquivo CSV foi criada uma task Rake que é executada rodando o comando:

```
$ rake data:import
```

Com isto os dados serão copiados para uma tabela `tests` no banco de dados criado seguindo os passos acima e ficarão acessíveis no endpoint `/tests`.