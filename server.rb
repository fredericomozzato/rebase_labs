require 'sinatra/base'
require_relative 'services/connection_service'
require_relative 'repositories/tests_repository'


class Server < Sinatra::Application
  get '/tests' do
    ConnectionService.with_pg_conn do |conn|
      test_repo = TestsRepository.new conn
      test_repo.select_all.to_json
    end
  end
end
