# Desafio Rebase Labs

Frederico Mozzato - mar/2024


### Subindo a aplicação
Foi configurado um arquivo do Docker Compose para que a aplicação suba com todas as dependências. Basta executar o comando

```
$ docker-compose up -d
```

e a aplicação estará acessível no container `app`, enquanto o banco de dados estará acessível no container `db`.

---

### Importar dados CSV
Para fazer o import dos dados do arquivo CSV foi criada uma task Rake que é executada rodando o comando:

```
$ rake data:import
```

**Importante:** O comando precisa ser rodado dentro do container `app`. Ou seja, pode-se entrar no container para executar o comando ou rodá-lo diretamente com

```
$ docker exec app sh -c "rake data:import"
```

O terminal retornará o seguinte texto em caso de sucesso:

```
=== Importando dados ===
=== Import concluído ===
```

Com isto os dados serão copiados para uma tabela `tests` no banco de dados criado seguindo os passos acima e ficarão acessíveis no endpoint `/tests`.

---

### Endpoints

Os dados dos exames estão disponíves no endpoint `GET /tests`. O retorno é um array com todas as linhas da tabela em formato JSON:

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