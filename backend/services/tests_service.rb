require 'csv'
require_relative '../repositories/tests_repository'
require_relative 'connection_service'
require_relative '../models/patient'

class TestsService < ConnectionService
  def self.get(page:, limit:)
    with_pg_conn do |conn|
      offset = limit * (page - 1)

      { tests: TestsRepository.new(conn).select(offset:, limit:) }.to_json
    end
  end
end
