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
end
