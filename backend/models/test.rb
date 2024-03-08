require_relative '../repositories/tests_repository'

class Test
  attr_accessor :id, :token, :date, :patient_id, :doctor_id

  def initialize(id: -1, token:, date:, patient_id:, doctor_id:)
    @id = id.to_i
    @token = token
    @date = date
    @patient_id = patient_id.to_i
    @doctor_id = doctor_id.to_i
  end

  def save
    TestsRepository.save_or_select self
  end

  def self.all
    TestsRepository.select_all
  end
end
