require_relative '../services/connection_service'
require_relative '../models/doctor'

class DoctorsRepository
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def save(doctor)
    sql = <<-SQL
      INSERT INTO doctors (name, email, crm, crm_state) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING;
    SQL

    @conn.exec sql, [doctor.name, doctor.email, doctor.crm, doctor.crm_state]

    find_by_crm doctor.crm
  end

  def find_by_id(id)
    sql = <<-SQL
      SELECT * FROM doctors WHERE id = $1;
    SQL

    data = @conn.exec(sql, [id]).first
    build_doctor data
  end

  def find_by_crm(crm)
    sql = <<-SQL
      SELECT * FROM doctors WHERE crm = $1;
    SQL

    data = @conn.exec(sql, [crm]).first
    build_doctor data
  end

  def select_all
    sql = <<-SQL
      SELECT * FROM doctors;
    SQL

    res = @conn.exec sql

    res.each_row.map do |row|
      Doctor.new(id: row[0], name: row[1], email: row[2], crm: row[3], crm_state: row[4])
    end
  end

  private

  def build_doctor(data)
    Doctor.new(id: data['id'],
               name: data['name'],
               email: data['email'],
               crm: data['crm'],
               crm_state: data['crm_state'])
  end
end
