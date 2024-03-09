require_relative '../services/connection_service'

class PatientsRepository
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def save(patient)
    sql = <<-SQL
      INSERT INTO patients (name, cpf, email, birthdate, address, city, state)
      VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING;
    SQL

    @conn.exec(sql, [patient.name, patient.cpf, patient.email, patient.birthdate, patient.address, patient.city, patient.state])

    find_by_cpf patient.cpf
  end

  def find_by_id(id)
    sql = <<-SQL
      SELECT * FROM patients WHERE id = $1
    SQL

    data = @conn.exec(sql, [id]).first
    build_patient data
  end

  def find_by_cpf(cpf)
    sql = <<-SQL
      SELECT * FROM patients WHERE cpf = $1;
    SQL

    data = @conn.exec(sql, [cpf]).first
    build_patient data
  end

  def select_all
    sql = <<-SQL
      SELECT * FROM patients;
    SQL

    res = @conn.exec sql

    res.each_row.map do |row|
      Patient.new(id: row[0].to_i, name: row[1], cpf: row[2], email: row[3],
                  birthdate: row[4], address: row[5], city: row[6], state: row[7])
    end
  end

  private

  def build_patient(data)
    Patient.new(id: data['id'],
                name: data['name'],
                cpf: data['cpf'],
                email: data['email'],
                birthdate: data['birthdate'],
                address: data['address'],
                city: data['city'],
                state: data['state'])
  end
end
