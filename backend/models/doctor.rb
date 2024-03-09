require_relative '../repositories/doctors_repository'

class Doctor
  attr_accessor :id, :name, :email, :crm, :crm_state

  def initialize(id: -1, name:, email:, crm:, crm_state:)
    @id = id.to_i
    @name = name
    @email = email
    @crm = crm
    @crm_state = crm_state
  end
end
