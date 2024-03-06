require 'sinatra/base'
require_relative 'services/tests_service'

class Server < Sinatra::Application
  get '/tests' do
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
    content_type :json
    begin
      TestsService.get
    rescue
      status 500
      {error: "O servidor encontrou um erro"}.to_json
    end
  end

  get '/up' do
    content_type :json
    {status: 'Online'}.to_json
  end
end
