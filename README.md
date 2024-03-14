# Desafio Rebase Labs

**Frederico Mozzato** | mar/2024

Este projeto foi desenvolvido como parte do desafio Rebase Labs com Ruby, Sinatra, PostgreSQL, Sidekiq e Docker. Os testes foram escritos com RSpec e Capybara.

 A aplicação consiste em 5 serviços:

- Frontend
- Backend
- Database
- Redis
- Sidekiq worker

Cada serviço roda em um container Docker separado.

## Subindo a aplicação
Foi configurado um arquivo Docker Compose para que a aplicação suba com todas as dependências. A partir da raíz da aplicação execute o comando

```
$ docker-compose up -d
```

e a aplicação estará no ar. O container `app` contém o frontend, `server` executa o backend enquanto o banco de dados estará acessível no container `db`. Ainda existem os containers do Redis e do woker com uma instância do Sidekiq rodando para fazer o processamento assíncrono dos jobs chamados no backend.

## Acessando a aplicação

O serviço frontend é responsável por subir o webapp. Este pode ser acessado no caminho `http://localhost:3000`. A página principal do app será exibida neste endereço. É possível importar arquivos usando o botão `importar` no menu de navegação.

**Apenas arquivos .csv são aceitos pelo sistema e devem respeitar a seguinte estrutura de colunas:**

`cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame`

Em caso de sucesso o backend irá importar os dados para o banco de forma assíncrona.

É possível navegar por exames e visualizar seus detalhes. A listagem de exames é feita de forma paginada, o que foi implementado diretamente na API.

## API
O container backend expões uma API que recebe requisições do tipo `GET` e `POST` na porta `4567`. Abaixo estão listados os endpoints:

### `GET:4567 /up`
Um endpoint usado para rapidamente checar o status da aplicação. Sua resposta é um JSON indicando que a aplicação está rodando corretamente:

```
{"status":"online"}
```

### `GET:4567 /tests`

Os dados dos exames adicionados ao banco. O retorno é um array com objetos em formato JSON:

```
[{
  "token":"T9O6AI",
  "date":"2021-11-21",
  "patient": {
     "cpf":"066.126.400-90",
     "name":"Matheus Barroso",
     "email":"maricela@streich.com",
     "birthdate":"1972-03-09"
  },
  "doctor": {
     "crm":"B000B7CDX4",
     "crm_state":"SP",
     "name":"Sra. Calebe Louzada"
  },
  "tests":[
     {
        "type":"hemácias",
        "range":"45-52",
        "result":"48"
     },
     {
        "type":"leucócitos",
        "range":"9-61",
        "result":"75"
     }
  ]
},
...]
```
Caso nenhum exame tenha sido adicionado ao banco o retorno é um array vazio.

### `GET tests/:token`
Retorna um exame identificado pelo seu token.

```
GET tests/IQCZ17

{
   "token":"IQCZ17",
   "date":"2021-08-05",
   "patient": {
      "cpf":"048.973.170-88",
      "name":"Emilly Batista Neto",
      "email":"gerald.crona@ebert-quigley.com",
      "birthdate":"2001-03-11"
   },
   "doctor": {
      "crm":"B000BJ20J4",
      "crm_state":"PI",
      "name":"Maria Luiza Pires"
   },
   "tests":[
      {
         "type":"hemácias",
         "range":"45-52",
         "result":"97"
      },
      {
         "type":"leucócitos",
         "range":"9-61",
         "result":"89"
      }
   ]
 }
```
Caso nenhum teste seja encontrado com o token requisitado a resposta retorna status `404 NOT FOUND` e uma mensagem de erro no corpo:

```
{"error":"Teste não encontrado"}
```

### `POST /import`
Este endpoint recebe arquivos .csv na estrutura exibida anteriormente. Por conta do endpoint ser dedicado a receber uploads do frontend ele espera alguns atributos que são criados pelo formulário HTML para upload, portanto um corpo de requisição precisa ter pelo menos os seguintes campos:

```
{"file": {"type":"text/csv", "tempfile":[arquivo para upload]}}
```

Caso a requisição seja bem sucedida o servidor responderá com status `202 ACCEPTED`, pois o import dos dados é feito de forma assíncrona por um job. Erros durante a execução do job disparam exceções que não são repassados ao usuário por conta do caráter assíncrono do serviço.

Caso o arquivo não seja aceito por conta da extensão ou do cabeçalho que não corresponde à estrutura, o servidor retorna respostas apropriadas:

```
415 UNSUPPORTED MEDIA TYPE
{"error":"Arquivo não é CSV"}


500 INTERNAL SERVER ERROR
{"error": "Cabeçalho fora das especificações"}
```

### Importar dados pelo backend
Para fazer o import dos dados via backend foi criada uma Rake task que é executada rodando o comando:

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

 Os dados são importados de um arquivo específico localizado no backend e, caso seja necessário importar dados de outro arquivo, deve-se substituir o conteúdo do arquivo em `app/persistence/data.csv` ou modificar o caminho dentro da task no arquivo `app/Rakefile` para o caminho do arquivo correto.


## Rodando os testes
Os testes foram escritos em RSpec e Capybara. Como o sistema conta com duas aplicações separadas cada uma inclui sua própria suite de testes. O backend é focado em testes de unidade e integração da API, enquanto o frontend em testes de sistema para o webapp.

Para rodar os testes do backend:

```
$ docker exec server rspec
```

Para rodar os testes de frontend:
```
$ docker exec app rspec
```
