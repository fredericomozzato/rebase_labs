# Desafio Rebase Labs

**Frederico Mozzato** | mar/2024


## Subindo a aplicação
Foi configurado um arquivo do Docker Compose para que a aplicação suba com todas as dependências. A partir da raíz da aplicação execute o comando

```
$ docker-compose up -d
```

e a aplicação estará no ar. O container `app` contém o frontend, `server` executa o backend enquanto o banco de dados estará acessível no container `db`.


## Importar dados CSV
Para fazer o import dos dados do arquivo CSV foi criada uma task Rake que é executada rodando o comando:

```
$ rake data:import
```

**Importante:** O comando precisa ser rodado dentro do container `server`. Ou seja, pode-se entrar no container para executar o comando ou rodá-lo diretamente com

```
$ docker exec server rake data:import
```

O terminal retornará o seguinte texto em caso de sucesso:

```
=== Importando dados ===
=== Import concluído ===
```

Com isto os dados serão copiados para uma tabela `tests` no banco de dados criado seguindo os passos acima e ficarão acessíveis no endpoint `/tests`.



## Endpoints

A aplicação está dividida em uma API que expões endpoints de dados e um frontend que os consome. A API fica exposta na porta `4567` enquanto o frontend usa a porta `3000`. 

Para acessar o frontend a URL é `http://localhost:3000/exames`.

Abaixo estão listados os endpoints referentes ao backend para consumo de dados:

### `GET:4567 /up`
Um endpoint usado para rapidamente checar o stuatus da aplicação. Sua resposta é um JSON indicando que a aplicação está rodando corretamente:

```
{"status":"online"}
```

### `GET:4567 /tests`

Os dados dos exames adicionados ao banco. O retorno é um array com todas as linhas da tabela em formato JSON:

```
[
  {
    "id":"1",
    "patient_cpf":"048.973.170-88",
    "patient_name":"Emilly Batista Neto",
    "patient_email":"gerald.crona@ebert-quigley.com",
    "patient_birthdate":"2001-03-11",
    "patient_address":"165 Rua Rafaela",
    "patient_city":"Ituverava",
    "patient_state":"Alagoas",
    "doctor_crm":"B000BJ20J4",
    "doctor_crm_state":"PI",
    "doctor_name":"Maria Luiza Pires",
    "doctor_email":"denna@wisozk.biz",
    "test_result_token":"IQCZ17",
    "test_date":"2021-08-05",
    "test_type":"hemácias",
    "test_type_range":"45-52",
    "test_result":"97"
  },
  {
    "id":"2",
    ...
  }
]
```

Caso nenhum exame tenha sido adicionado ao banco o retorno é um array vazio.



## Rodando os testes
A suite de testes foi feita usando RSpec. Os testes foram implementados para o backend, portanto para rodá-los a partir do host use o comando:

```
$ docker exec server rspec
```
