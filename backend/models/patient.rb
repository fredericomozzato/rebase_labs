require_relative '../repositories/patients_repository'

class Patient
  attr_accessor :id, :name, :cpf, :email, :birthdate,
                :address, :city, :state

  def initialize(id: -1, name:, cpf:, email:, birthdate:, address:, city:, state:)
    @id = id.to_i
    @name = name
    @cpf = cpf
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
  end

  def to_hash
    { cpf:, name:, email:, birthdate: }
  end
end
