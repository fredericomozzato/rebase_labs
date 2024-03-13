require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    redirect to('/exames')
  end

  get '/exames' do
    content_type 'text/html'
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/import' do
    content_type 'text/html'
    send_file File.join(settings.public_folder, 'import.html')
  end
end
