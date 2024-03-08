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

  def self.select_all
    sql = <<-SQL
      SELECT * FROM patients;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'select_all_patients', sql
      conn.exec_prepared 'select_all_patients'
    end

    res.each_row.map do |row|
      Patient.new(id: row[0].to_i, name: row[1], cpf: row[2], email: row[3],
                  birthdate: row[4], address: row[5], city: row[6], state: row[7])
    end
  end
end
