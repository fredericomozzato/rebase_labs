require 'pg'

class ConnectionService
  def self.with_pg_conn
    conn = PG::Connection.new host: '127.0.0.1',
                              port: 5432,
                              dbname: 'relabs',
                              user: 'user',
                              password: 'pswd'
    yield conn
  ensure
    conn&.close
  end
end
