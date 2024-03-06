require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    content_type 'text/html'
    '<h1>Home page</h1>'
  end

  get '/exames' do
    content_type 'text/html'
    send_file File.join(settings.public_folder, 'index.html')
  end
end
