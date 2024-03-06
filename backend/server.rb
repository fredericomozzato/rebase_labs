require 'sinatra/base'
require_relative 'services/tests_service'

class Server < Sinatra::Application
  DEFAULT_LIMIT = 25
  DEFAULT_PAGE = 1

  get '/tests' do
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
    content_type :json
    begin
      page  = params[:page]&.to_i  || DEFAULT_PAGE
      limit = params[:limit]&.to_i || DEFAULT_LIMIT
      TestsService.get(page:, limit:)
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
