require_relative '../repositories/test_types_repository'

class TestType
  attr_accessor :id, :type, :range, :result, :test_id

  def initialize(id: -1, type:, range:, result:, test_id:)
    @id = id.to_i
    @type = type
    @range = range
    @result = result.to_i
    @test_id = test_id.to_i
  end
end
