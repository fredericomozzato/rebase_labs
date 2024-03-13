require 'sinatra/base'
require_relative 'services/api_service'

class App < Sinatra::Base
  get '/' do
    redirect to('/exames')
  end

  get '/exames' do
    content_type 'text/html'
    send_file File.join(settings.public_folder, 'index.html')
  end

  post '/upload' do
    # {"file"=>{"filename"=>"reduced_data.csv", "type"=>"text/csv", "name"=>"file", "tempfile"=>#<Tempfile:/tmp/RackMultipart20240313-7-hyc79k.csv>, "head"=>"Content-Disposition: form-data; name=\"file\"; filename=\"reduced_data.csv\"\r\nContent-Type: text/csv\r\n"}}

    # p type
    # p file

    # call upload service with type and tempfile
    ApiService.upload(params:)

    redirect to('/exames')
  end
end
