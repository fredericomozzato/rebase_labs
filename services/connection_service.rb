require 'pg'

class ConnectionService
  def self.with_pg_conn
    conn = PG::Connection.new host: 'db',
                              port: 5432,
                              dbname: 'relabs',
                              user: 'relabs',
                              password: 'relabs'
    yield conn
  ensure
    conn&.close
  end
end
