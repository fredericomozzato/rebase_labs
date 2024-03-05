require 'spec_helper'

RSpec.describe Server, type: :request do
  describe 'GET /up' do
    it 'retorna status 200 e mensagem' do
      get '/up'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body).to eq '{"status":"Servidor online"}'
    end
  end

  describe 'GET /tests' do
    it 'retorna um array vazio se não existem dados no banco' do
      get '/tests'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body).to eq '[]'
    end

    it 'retorna mensagem em caso de erros de conexão' do
      allow(TestsRepository).to receive(:new).and_raise PG::ConnectionBad
      get '/tests'

      expect(last_response.status).to eq 500
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body.force_encoding('UTF-8')).to eq '{"error":"O servidor encontrou um erro"}'
    end

    it 'retorna dados de exames do banco' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      get '/tests'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body.force_encoding('UTF-8')).to include '048.973.170-88'
      expect(last_response.body.force_encoding('UTF-8')).to include 'Emilly Batista Neto'
      expect(last_response.body.force_encoding('UTF-8')).to include 'gerald.crona@ebert-quigley.com'
      expect(last_response.body.force_encoding('UTF-8')).to include '2001-03-11'
      expect(last_response.body.force_encoding('UTF-8')).to include '165 Rua Rafaela'
      expect(last_response.body.force_encoding('UTF-8')).to include 'Ituverava'
      expect(last_response.body.force_encoding('UTF-8')).to include 'Alagoas'
      expect(last_response.body.force_encoding('UTF-8')).to include 'B000BJ20J4'
      expect(last_response.body.force_encoding('UTF-8')).to include 'PI'
      expect(last_response.body.force_encoding('UTF-8')).to include 'Maria Luiza Pires'
      expect(last_response.body.force_encoding('UTF-8')).to include 'denna@wisozk.biz'
      expect(last_response.body.force_encoding('UTF-8')).to include 'IQCZ17'
      expect(last_response.body.force_encoding('UTF-8')).to include '2021-08-05'
      expect(last_response.body.force_encoding('UTF-8')).to include 'hemácias'
      expect(last_response.body.force_encoding('UTF-8')).to include '45-52'
      expect(last_response.body.force_encoding('UTF-8')).to include '97'
    end
  end
end
