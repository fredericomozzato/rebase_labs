require 'spec_helper'

RSpec.describe TestType, type: :model do
  describe '#save' do
    it 'Salva tipo de teste no banco caso este não exista' do
      patient = Patient.new(
                  name: 'Fulano',
                  cpf: '000.000.000-00',
                  email: 'fulano@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Fulanópolis',
                  state: 'Acre'
                ).save
      doctor = Doctor.new(
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
              ).save
      test_type = TestType.new(
        type: 'plaquetas',
        range: '48-72',
        result: 69,
        test_id: test.id
      )

      res = test_type.save

      expect(res).to be_a TestType
      expect(res.id).to eq 1
    end
  end
end
