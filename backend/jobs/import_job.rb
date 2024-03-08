require 'csv'
require_relative '../models/patient'
require_relative '../models/doctor'
require_relative '../models/test'
require_relative '../models/test_type'
require_relative '../services/connection_service'

class ImportJob < ConnectionService
  def self.perform(file:)
    rows = CSV.read file, col_sep: ';'

    with_pg_conn do |conn|
      rows.slice(1..).each do |row|
        # extract patient data
        patient = Patient.new(cpf: row[0], name: row[1], email: row[2], birthdate: row[3],
                              address: row[4], city: row[5], state: row[6]).save

        # extract doctor data
        doctor = Doctor.new(crm: row[7], crm_state: row[8], name: row[9], email: row[10]).save

        # extract test data
        test = Test.new(token: row[11], date: row[12], patient_id: patient.id, doctor_id: doctor.id).save

        # extract test_type data
        test_type = TestType.new(type: row[13], range: row[14], result: row[15], test_id: test.id).save
      end
    end
  end
end
