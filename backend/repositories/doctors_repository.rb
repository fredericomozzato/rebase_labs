require_relative '../services/connection_service'
require 'byebug'

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

    find_doctor_by_crm doctor.crm
  end

  def find_doctor_by_crm(crm)
    sql = <<-SQL
      SELECT * FROM doctors WHERE crm = $1;
    SQL

    data = @conn.exec(sql, [crm]).first

    Doctor.new(id: data['id'], name: data['name'], email: data['email'],
                crm: data['crm'], crm_state: data['crm_state'])
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
end
