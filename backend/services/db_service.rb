require_relative 'connection_service'

class DbService < ConnectionService
  def self.setup_test_db
    with_pg_conn do |conn|
      sql = File.read(File.join(__dir__, '..', 'persistence', 'test_db_setup.sql')).to_s
      conn.exec sql
    end
  end

  def self.cleanup_test_db
    with_pg_conn do |conn|
      sql = <<-SQL
        TRUNCATE TABLE patients,
                       doctors,
                       tests,
                       test_types
      SQL

      conn.exec sql
    end
  end
end
