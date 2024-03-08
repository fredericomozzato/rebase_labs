require_relative '../services/connection_service'

class PatientsRepository < ConnectionService
  def self.save_or_select(patient)
    sql = <<-SQL
      INSERT INTO patients (name, cpf, email, birthdate, address, city, state)
      VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'insert_patient', sql
      conn.exec_prepared('insert_patient', [patient.name, patient.cpf, patient.email, patient.birthdate,
                      patient.address, patient.city, patient.state])
    end

    self.find_by_cpf patient.cpf
  end

  def self.find_by_cpf(cpf)
    sql = <<-SQL
      SELECT * FROM patients WHERE cpf = $1;
    SQL

    data = with_pg_conn do |conn|
      conn.prepare 'find_by_cpf', sql
      conn.exec_prepared 'find_by_cpf', [cpf]
    end.first

    Patient.new(
      id: data['id'].to_i, name: data['name'], cpf: data['cpf'], email: data['email'],
      birthdate: data['birthdate'], address: data['address'], city: data['city'], state: data['state']
      )
  end
end
