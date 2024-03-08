require_relative '../services/connection_service'

class DoctorsRepository < ConnectionService
  def self.save_or_select(doctor)
    sql = <<-SQL
      INSERT INTO doctors (name, email, crm, crm_state) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'insert_doctor', sql
      conn.exec_prepared 'insert_doctor', [doctor.name, doctor.email, doctor.crm, doctor.crm_state]
    end

    self.find_doctor_by_crm doctor.crm, doctor.crm_state
  end

  def self.find_doctor_by_crm(crm, crm_state)
    sql = <<-SQL
      SELECT * FROM doctors WHERE crm = $1 AND crm_state = $2;
    SQL

    data = with_pg_conn do |conn|
      conn.prepare 'find_by_crm', sql
      conn.exec_prepared 'find_by_crm', [crm, crm_state]
    end.first

    Doctor.new(id: data['id'], name: data['name'], email: data['email'],
                crm: data['crm'], crm_state: data['crm_state'])
  end

  def self.select_all
    sql = <<-SQL
      SELECT * FROM doctors;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'select_all_doctors', sql
      conn.exec_prepared 'select_all_doctors'
    end

    res.each_row.map do |row|
      Doctor.new(id: row[0], name: row[1], email: row[2], crm: row[3], crm_state: row[4])
    end
  end
end
