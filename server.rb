require 'sinatra/base'
require_relative 'services/tests_service'

class Server < Sinatra::Application
  get '/tests' do
    TestsService.get
  end

  get '/up' do
    'Servidor online'
  end
end
