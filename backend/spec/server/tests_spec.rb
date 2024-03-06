require 'spec_helper'

RSpec.describe Server do
  describe 'GET /tests' do
    it 'retorna um array vazio se não existem dados no banco' do
      get '/tests'

      json_data = JSON.parse last_response.body, symbolize_names: true
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq({ tests: [] })
    end

    it 'retorna dados de exames do banco' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      get '/tests'

      json_data = JSON.parse last_response.body
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(json_data).to eq("tests"=> [
        { "id"=>"1",
          "patient_cpf"=>"048.973.170-88",
          "patient_name"=>"Emilly Batista Neto",
          "patient_email"=>"gerald.crona@ebert-quigley.com",
          "patient_birthdate"=>"2001-03-11",
          "patient_address"=>"165 Rua Rafaela",
          "patient_city"=>"Ituverava",
          "patient_state"=>"Alagoas",
          "doctor_crm"=>"B000BJ20J4",
          "doctor_crm_state"=>"PI",
          "doctor_name"=>"Maria Luiza Pires",
          "doctor_email"=>"denna@wisozk.biz",
          "test_result_token"=>"IQCZ17",
          "test_date"=>"2021-08-05",
          "test_type"=>"hemácias",
          "test_type_range"=>"45-52",
          "test_result"=>"97" }
        ])
    end

    it 'retorna mensagem em caso de erros de conexão' do
      allow(TestsRepository).to receive(:new).and_raise PG::ConnectionBad
      get '/tests'

      expect(last_response.status).to eq 500
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body.force_encoding('UTF-8')).to eq '{"error":"O servidor encontrou um erro"}'
    end
  end
end
