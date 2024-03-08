require 'spec_helper'

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

  describe '.all' do
    it 'Retorna todos os testes do banco de dados' do
      patient1 = Patient.new(
                  name: 'Fulano',
                  cpf: '000.000.000-00',
                  email: 'fulano@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Fulanópolis',
                  state: 'Acre'
                ).save
      doctor1 =  Doctor.new(
                  name: 'Doutor Fulano',
                  email: 'dr_fulano@email.com',
                  crm: '1234567890',
                  crm_state: 'AC'
                ).save
      test1 = Test.new(
        token: '123456',
        date: '2024-03-08',
        patient_id: patient1.id,
        doctor_id: doctor1.id
      ).save
      patient2 = Patient.new(
                  name: 'Siclana',
                  cpf: '000.000.000-01',
                  email: 'siclana@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Siclanópolis',
                  state: 'Acre'
                ).save
      doctor2 =  Doctor.new(
                  name: 'Doutora Siclana',
                  email: 'dra_siclana@email.com',
                  crm: '0987654321',
                  crm_state: 'AC'
                ).save
      test2 = Test.new(
        token: '654321',
        date: '2024-03-07',
        patient_id: patient2.id,
        doctor_id: doctor2.id
      ).save

      all_tests = Test.all

      expect(all_tests.count).to eq 2
      expect(all_tests[0].token).to eq '123456'
      expect(all_tests[0].patient_id).to eq 1
      expect(all_tests[1].token).to eq '654321'
      expect(all_tests[1].patient_id).to eq 2
    end

    it 'Retorna um array vazio se não existem dados na tabela' do
      expect(Test.all).to be_empty
    end
  end
end
