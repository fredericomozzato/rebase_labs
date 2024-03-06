require 'sinatra/base'

class App < Sinatra::Application
  get '/' do
    'Frontend Home'
  end
end
