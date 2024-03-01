require_relative '../repositories/tests_repository'
require_relative 'connection_service'

class TestsService < ConnectionService
  def self.get
    with_pg_conn do |conn|
      TestsRepository.new(conn).select_all.to_json
    end
  end

  def self.insert(rows)
    with_pg_conn do |conn|
      test_repo = TestsRepository.new conn
      rows.slice(1..). each do |row|
        test_repo.insert test_data: row
      end
    end
  end
end
