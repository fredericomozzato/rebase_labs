require 'spec_helper'

RSpec.describe Patient, type: :model do
  describe '#save' do
    it 'Salva paciente no banco de dados caso este não exista' do
      patient = Patient.new(
        name: 'Fulano',
        cpf: '000.000.000-00',
        email: 'fulano@email.com',
        birthdate: '1990-12-31',
        address: 'Rua Alguma Coisa e Tal',
        city: 'Fulanópolis',
        state: 'Acre'
      )

      res = patient.save

      expect(res).to be_a Patient
      expect(res.id).to eq(1)
    end

    it 'Retorna paciente caso este já esteja salvo no banco' do
      Patient.new(
        name: 'Fulano',
        cpf: '000.000.000-00',
        email: 'fulano@email.com',
        birthdate: '1990-12-31',
        address: 'Rua Alguma Coisa e Tal',
        city: 'Fulanópolis',
        state: 'Acre'
      ).save

      existing_patient = Patient.new(
        name: 'Fulano',
        cpf: '000.000.000-00',
        email: 'fulano@email.com',
        birthdate: '1990-12-31',
        address: 'Rua Alguma Coisa e Tal',
        city: 'Fulanópolis',
        state: 'Acre'
      )

      res = existing_patient.save

      expect(res).to be_a Patient
      expect(res.id).to eq 1
    end
  end
end
