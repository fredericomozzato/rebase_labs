require_relative '../repositories/tests_repository'

class Test
  attr_accessor :id, :token, :date, :patient_id, :doctor_id

  def initialize(id: -1, token:, date:, patient_id:, doctor_id:)
    @id = id
    @token = token
    @date = date
    @patient_id = patient_id
    @doctor_id = doctor_id
  end

  def save
    TestsRepository.save_or_select self
  end
end
