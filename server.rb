require 'sinatra/base'
require 'csv'

class Server < Sinatra::Application
  get '/tests' do
    { message: "Test" }.to_json
  end
end
