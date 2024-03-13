require 'sinatra/base'
require 'rack-flash'
require_relative 'services/api_service'

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  get '/' do
    redirect to('/exames')
  end

  get '/exames' do
    erb :index
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

  get '/exames/:token' do
    @test = ApiService.search token: params[:token]
    p @test

    erb :test
  end
end
