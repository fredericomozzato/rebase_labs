require_relative '../repositories/test_types_repository'

class TestType
  attr_accessor :id, :type, :range, :result, :test_id

  def initialize(id: -1, type:, range:, result:, test_id:)
    @id = id
    @type = type
    @range = range
    @result = result
    @test_id = test_id
  end

  def save
    TestTypesRepository.save self
  end
end
