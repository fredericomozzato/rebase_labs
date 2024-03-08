require_relative '../services/connection_service'

class DoctorsRepository < ConnectionService
  def self.save_or_select(doctor)
    sql = <<-SQL
      INSERT INTO doctors (name, email, crm, crm_state) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING;
    SQL

    res = with_pg_conn do |conn|
      conn.exec sql, [doctor.name, doctor.email, doctor.crm, doctor.crm_state]
    end

    self.find_doctor_by_crm doctor.crm, doctor.crm_state
  end

  def self.find_doctor_by_crm(crm, crm_state)
    sql = <<-SQL
      SELECT * FROM doctors WHERE crm = $1 AND crm_state = $2;
    SQL

    res = with_pg_conn do |conn|
      conn.exec sql, [crm, crm_state]
    end.first

    Doctor.new(id: res['id'].to_i, name: res['name'], email: res['email'],
                crm: res['crm'], crm_state: res['crm_state'])
  end
end
