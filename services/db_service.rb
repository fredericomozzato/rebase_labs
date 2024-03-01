require 'pg'

class DbService
  attr_reader :conn

  def initialize
    @conn = PG::Connection.new host: '127.0.0.1',
                               port: 5432,
                               dbname: 'relabs',
                               user: 'user',
                               password: 'pswd'
  end

  def setup
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS tests (
        id SERIAL PRIMARY KEY,
        patient_cpf CHAR(14),
        patient_name VARCHAR(50),
        patient_email VARCHAR(50),
        patient_birthdate DATE,
        patient_address VARCHAR(100),
        patient_city VARCHAR(50),
        patient_state VARCHAR(20),
        doctor_crm CHAR(10),
        doctor_crm_state CHAR(2),
        doctor_name VARCHAR(50),
        doctor_email VARCHAR(50),
        test_result_token CHAR(6),
        test_date DATE,
        test_type VARCHAR(20),
        test_type_range VARCHAR(10),
        test_result INTEGER
      );
    SQL
  begin
    result = @conn.exec sql
  ensure
    @conn.close
  end
  end
end
