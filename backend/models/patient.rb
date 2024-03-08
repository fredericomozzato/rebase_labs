require_relative '../repositories/patients_repository'

class Patient
  attr_accessor :id, :name, :cpf, :email, :birthdate,
                :address, :city, :state

  def initialize(id: -1, name:, cpf:, email:, birthdate:, address:, city:, state:)
    @id = id
    @name = name
    @cpf = cpf
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
  end

  def save
    PatientsRepository.save_or_select self
  end

  def self.all
    PatientsRepository.select_all
  end
end
