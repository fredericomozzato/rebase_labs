require 'spec_helper'

RSpec.describe Server do
  describe 'GET /tests' do
    it 'retorna um array vazio se não existem dados no banco' do
      get '/tests'

      json_data = JSON.parse last_response.body, symbolize_names: true
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq []
    end

    it 'retorna dados de exames do banco' do
      ImportJob.perform(file: File.open(
        File.join(__dir__, '..', 'support', 'reduced_data.csv')
      ))

      get '/tests'

      expected_response = File.read(
        File.join(__dir__, '..', 'support', 'response_spec.json')
      )
      json_data = JSON.parse last_response.body
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq(JSON.parse(expected_response))
    end

    it 'retorna mensagem em caso de erros de conexão' do
      allow(TestsRepository).to receive(:new).and_raise PG::ConnectionBad
      get '/tests'

      expect(last_response.status).to eq 500
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body.force_encoding('UTF-8')).to eq '{"error":"O servidor encontrou um erro"}'
    end
  end

  describe 'GET /tests/:token' do
    it 'Retorna teste de acordo com o token pesquisado' do
      ImportJob.perform(file: File.open(
        File.join(__dir__, '..', 'support', 'extended_data.csv')
      ))

      token = 'T9O6AI'
      get "/tests/#{token}"

      json_data = JSON.parse last_response.body, symbolize_names: true

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq(
        {"token":"T9O6AI",
          "date":"2021-11-21",
          "patient": {"cpf":"066.126.400-90",
                      "name":"Matheus Barroso",
                      "email":"maricela@streich.com",
                      "birthdate":"1972-03-09"},
          "doctor":  {"crm":"B000B7CDX4",
                      "crm_state":"SP",
                      "name":"Sra. Calebe Louzada"},
          "tests":  [{"type":"hemácias","range":"45-52","result":"48"},
                     {"type":"leucócitos","range":"9-61","result":"75"},
                     {"type":"plaquetas","range":"11-93","result":"67"},
                     {"type":"hdl","range":"19-75","result":"3"},
                     {"type":"ldl","range":"45-54","result":"27"},
                     {"type":"vldl","range":"48-72","result":"27"},
                     {"type":"glicemia","range":"25-83","result":"78"},
                     {"type":"tgo","range":"50-84","result":"15"},
                     {"type":"tgp","range":"38-63","result":"34"},
                     {"type":"eletrólitos","range":"2-68","result":"92"},
                     {"type":"tsh","range":"25-80","result":"21"},
                     {"type":"t4-livre","range":"34-60","result":"95"},
                     {"type":"ácido úrico","range":"15-61","result":"10"}]}
      )
    end

    it 'Retorna NOT FOUND se o token não existe no banco' do
      get 'tests/000000'

      json_data = JSON.parse last_response.body, symbolize_names: true

      expect(last_response.status).to eq 404
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq({error: "Teste não encontrado"})
    end
  end
end
