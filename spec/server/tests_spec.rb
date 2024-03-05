require 'spec_helper'

RSpec.describe Server, type: :request do
  describe 'GET /up' do
    it 'retorna status 200 e mensagem' do
      get '/up'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Servidor online'
    end
  end

  describe 'GET /tests' do
    it 'retorna um array vazio se não existem dados no banco' do
      get '/tests'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq '[]'
    end
  end
end
