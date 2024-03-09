require_relative '../services/connection_service'

class TestsRepository
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def save(test)
    sql = <<-SQL
      INSERT INTO tests (token, date, patient_id, doctor_id) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING;
    SQL

    @conn.exec sql, [test.token, test.date, test.patient_id, test.doctor_id]

    find_by_token test.token
  end

  def find_by_token(token)
    sql = <<-SQL
      SELECT * FROM tests WHERE token = $1;
    SQL

    data = @conn.exec(sql, [token]).first

    Test.new(id: data['id'].to_i, token: data['token'], date: data['date'],
             patient_id: data['patient_id'], doctor_id: data['doctor_id'])
  end

  def select_all
    sql = <<-SQL
      SELECT * FROM tests;
    SQL

    res = @conn.exec sql

    res.each_row.map do |row|
      Test.new(id: row[0], token: row[1], date: row[2], patient_id: row[3], doctor_id: row[4])
    end
  end

  def select(offset:, limit:)
    sql = <<-SQL
      SELECT * from tests OFFSET $1 LIMIT $2;
    SQL

    @conn.exec(sql, [offset, limit]).each_row.map do |row|
      {
        id: row[0],
        patient_cpf: row[1],
        patient_name: row[2],
        patient_email: row[3],
        patient_birthdate: row[4],
        patient_address: row[5],
        patient_city: row[6],
        patient_state: row[7],
        doctor_crm: row[8],
        doctor_crm_state: row[9],
        doctor_name: row[10],
        doctor_email: row[11],
        test_result_token: row[12],
        test_date: row[13],
        test_type: row[14],
        test_type_range: row[15],
        test_result: row[16]
      }
    end
  end
end
