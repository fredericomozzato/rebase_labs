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
end
