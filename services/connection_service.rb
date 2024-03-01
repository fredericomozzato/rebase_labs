require 'pg'

class ConnectionService
  def self.conn
    @conn = PG::Connection.new host: '127.0.0.1',
                               port: 5432,
                               dbname: 'relabs',
                               user: 'user',
                               password: 'pswd'
  end
end
