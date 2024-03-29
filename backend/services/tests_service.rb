require 'csv'
require 'json'
require_relative '../repositories/tests_repository'
require_relative '../repositories/patients_repository'
require_relative '../repositories/doctors_repository'
require_relative '../repositories/test_types_repository'
require_relative 'connection_service'
require_relative '../models/patient'

class TestsService < ConnectionService
  def self.get(page:, limit:)
    offset = limit * (page - 1)

    with_pg_conn do |conn|
      tests_repo = TestsRepository.new conn

      tests_repo.select_paginated(offset:, limit:).map do |test|
        self.build_response(conn:, test:)
      end.to_json
    end
  end

  def self.get_by_token(token:)
    with_pg_conn do |conn|
      tests_repo = TestsRepository.new conn

      test = tests_repo.find_by_token(token)
      self.build_response(conn:, test:).to_json
    end
  end

  def self.build_response(conn:, test:)
    patients_repo = PatientsRepository.new conn
    doctors_repo = DoctorsRepository.new conn
    test_types_repo = TestTypesRepository.new conn

    {
      token: test.token,
      date: test.date,
      patient: patients_repo.find_by_id(test.patient_id).to_hash,
      doctor: doctors_repo.find_by_id(test.doctor_id).to_hash,
      tests: test_types_repo.find_all_by_test_id(test.id).map(&:to_hash)
    }
  end
  private_class_method :build_response
end
