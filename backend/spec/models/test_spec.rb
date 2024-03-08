require 'spec_helper'
require_relative '../../models/test'
require_relative '../../models/doctor'
require_relative '../../models/patient'

RSpec.describe Test, type: :model do
  describe '#save' do
    it 'Salva teste no banco caso este não exista' do
      patient = Patient.new(
                  name: 'Fulano',
                  cpf: '000.000.000-00',
                  email: 'fulano@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Fulanópolis',
                  state: 'Acre'
                ).save
      doctor =  Doctor.new(
                  name: 'Doutor Fulano',
                  email: 'dr_fulano@email.com',
                  crm: '1234567890',
                  crm_state: 'AC'
                ).save
      test = Test.new(
        token: '123456',
        date: '2024-03-08',
        patient_id: patient.id,
        doctor_id: doctor.id
      )

      res = test.save

      expect(res).to be_a Test
      expect(res.id).to eq 1
    end

    it 'Retorna teste caso este já esteja salvo no banco' do
      patient = Patient.new(
                  name: 'Fulano',
                  cpf: '000.000.000-00',
                  email: 'fulano@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Fulanópolis',
                  state: 'Acre'
                ).save
      doctor =  Doctor.new(
                  name: 'Doutor Fulano',
                  email: 'dr_fulano@email.com',
                  crm: '1234567890',
                  crm_state: 'AC'
                ).save
      Test.new(
        token: '123456',
        date: '2024-03-08',
        patient_id: patient.id,
        doctor_id: doctor.id
      ).save
      existing_test = Test.new(
        token: '123456',
        date: '2024-03-08',
        patient_id: patient.id,
        doctor_id: doctor.id
      )

      res = existing_test.save

      expect(res).to be_a Test
      expect(res.id).to eq 1
    end
  end
end
