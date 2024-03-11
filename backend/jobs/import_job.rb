require 'csv'
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
  def self.perform(file:)
    self.validate_headers file

    rows = CSV.read file, col_sep: ';'

    with_pg_conn do |conn|
      patients_repo = PatientsRepository.new conn
      doctors_repo = DoctorsRepository.new conn
      tests_repo = TestsRepository.new conn
      test_types_repo = TestTypesRepository.new conn

      conn.transaction do
        rows.slice(1..).each_with_index do |row, i|
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

  def self.validate_headers(file)
    expected_headers = [
      "cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame"
    ]

    actual_headers = CSV.read(file, headers: true).headers

    raise CustomErrors::InvalidCsvHeader.new unless actual_headers == expected_headers
  end
  private_class_method :validate_headers
end
