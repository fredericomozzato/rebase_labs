require 'csv'
require 'sidekiq'
require_relative '../lib/custom_errors'
require_relative '../models/patient'
require_relative '../models/doctor'
require_relative '../models/test'
require_relative '../models/test_type'
require_relative '../services/connection_service'
require_relative '../repositories/doctors_repository'
require_relative '../repositories/patients_repository'
require_relative '../repositories/tests_repository'
require_relative '../repositories/test_types_repository'

class ImportJob < ConnectionService
  include Sidekiq::Job

  def perform(csv_rows)
    ConnectionService.with_pg_conn do |conn|
      patients_repo = PatientsRepository.new conn
      doctors_repo = DoctorsRepository.new conn
      tests_repo = TestsRepository.new conn
      test_types_repo = TestTypesRepository.new conn

      conn.transaction do
        csv_rows.slice(1..).each_with_index do |row, i|
          patient = patients_repo.save(Patient.new(
            cpf: row[0], name: row[1], email: row[2], birthdate: row[3], address: row[4], city: row[5], state: row[6]
          ))

          doctor = doctors_repo.save(Doctor.new(
            crm: row[7], crm_state: row[8], name: row[9], email: row[10]
          ))

          test = tests_repo.save(Test.new(
            token: row[11], date: row[12], patient_id: patient.id, doctor_id: doctor.id
          ))

          test_type = test_types_repo.save(TestType.new(
            type: row[13], range: row[14], result: row[15], test_id: test.id
          ))
        end
      end
    end
  end
end
