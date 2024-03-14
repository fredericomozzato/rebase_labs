require 'sinatra/base'
require 'rack-flash'
require 'byebug'
require_relative 'services/api_service'

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  ENV['PORT'] ||= '3000'

  before do
    response.headers["Access-Control-Allow-Origin"] = '*'
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
  end

  get '/' do
    redirect to('/exames')
  end

  get '/exames' do
    erb :index
  end

  get '/tests' do
    ApiService.select_all(page: params[:page], limit: params[:limit])
  end

  get '/tests/:token' do
    ApiService.search token: params[:token]
  end

  post '/upload' do
    if params.empty?
      flash[:alert] = 'Anexe um arquivo válido'
      return redirect to('/exames')
    end

    res = ApiService.upload(params:)

    if res.status == 202
      flash[:notice] = 'Seu upload está sendo processado'
    else
      flash[:alert] = 'Erro. Arquivo não pode ser processado'
    end

    redirect to('/exames')
  end
end
