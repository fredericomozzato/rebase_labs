require 'sinatra/base'

class Server < Sinatra::Application
  get '/tests' do
    { key: "value" }.to_json
  end
end
