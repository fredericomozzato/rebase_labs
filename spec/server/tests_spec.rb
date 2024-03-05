require 'spec_helper'

RSpec.describe Server, type: :request do
  describe 'GET /tests' do
    it 'retorna um array vazio se não existem dados no banco' do
      get '/tests'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body).to eq '[]'
    end

    it 'retorna dados de exames do banco' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      get '/tests'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to include 'application/json'
      expect(last_response.body).to include('048.973.170-88', 'Emilly Batista Neto', 'gerald.crona@ebert-quigley.com',
                                            '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'B000BJ20J4',
                                            'PI', 'Maria Luiza Pires', 'denna@wisozk.biz', 'IQCZ17', '2021-08-05',
                                            'hemácias', '45-52', '97')
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
