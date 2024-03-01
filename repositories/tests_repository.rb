require 'pg'

class TestsRepository
  def initialize(conn)
    @conn = conn
  end

  def insert(test_data:)
    sql = <<-SQL
      INSERT INTO tests (
        patient_cpf,
        patient_name,
        patient_email,
        patient_birthdate,
        patient_address,
        patient_city,
        patient_state,
        doctor_crm,
        doctor_crm_state,
        doctor_name,
        doctor_email,
        test_result_token,
        test_date,
        test_type,
        test_type_range,
        test_result
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);
    SQL

    @conn.exec sql, test_data
  end

  def select_all
    sql = <<-SQL
      SELECT * from tests;
    SQL

    @conn.exec(sql).each_row.map do |row|
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
