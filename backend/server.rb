require 'sinatra/base'
require 'sinatra/cors'
require_relative 'lib/custom_errors'
require_relative 'services/tests_service'
require_relative 'services/import_service'

class Server < Sinatra::Application
  include CustomErrors

  register Sinatra::Cors
  set :allow_origin, 'http://localhost:3000 http://frontend:3000'
  set :allow_methods, 'GET POST'

  DEFAULT_LIMIT = 25
  DEFAULT_PAGE = 1

  before do
    content_type :json
  end

  get '/up' do
    content_type :json
    {status: 'Online'}.to_json
  end

  get '/tests' do
  begin
    page  = params[:page]&.to_i  || DEFAULT_PAGE
    limit = params[:limit]&.to_i || DEFAULT_LIMIT
    TestsService.get(page:, limit:)
  rescue
    status 500
    {error: "O servidor encontrou um erro"}.to_json
  end
  end

  get '/tests/:token' do
  begin
    TestsService.get_by_token token: params[:token]
  rescue PG::NoResultError
    status 404
    { error: 'Teste não encontrado' }.to_json
  end
  end

  post '/import' do
  begin
    ImportService.import params[:file]
    status 202
  rescue InvalidFileExtension => e
    status 415
    { error: e.message }.to_json
  end
  end
end
