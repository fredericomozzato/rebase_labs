require 'spec_helper'

RSpec.describe TestsRepository do
  describe '#save' do
    it 'Salva teste no banco caso este não exista' do
      res = ConnectionService.with_pg_conn do |conn|
        patient = PatientsRepository.new(conn).save(
          Patient.new(name: 'Fulano',
                      cpf: '000.000.000-00',
                      email: 'fulano@email.com',
                      birthdate: '1990-12-31',
                      address: 'Rua Alguma Coisa e Tal',
                      city: 'Fulanópolis',
                      state: 'Acre')
        )
        doctor = DoctorsRepository.new(conn).save(
          Doctor.new(name: 'Doutor Fulano',
                     email: 'dr_fulano@email.com',
                     crm: '1234567890',
                     crm_state: 'AC')
        )
        test = TestsRepository.new(conn).save(
          Test.new(token: '123456',
                   date: '2024-03-08',
                   patient_id: patient.id,
                   doctor_id: doctor.id)
        )
      end

      expect(res).to be_a Test
      expect(res.id).to eq 1
    end

    it 'Retorna teste caso este já esteja salvo no banco' do
      res = ConnectionService.with_pg_conn do |conn|
        patient = PatientsRepository.new(conn).save(
          Patient.new(name: 'Fulano',
                      cpf: '000.000.000-00',
                      email: 'fulano@email.com',
                      birthdate: '1990-12-31',
                      address: 'Rua Alguma Coisa e Tal',
                      city: 'Fulanópolis',
                      state: 'Acre')
        )
        doctor = DoctorsRepository.new(conn).save(
          Doctor.new(name: 'Doutor Fulano',
                     email: 'dr_fulano@email.com',
                     crm: '1234567890',
                     crm_state: 'AC')
        )

        test_repo = TestsRepository.new conn
        test_repo.save(Test.new(
          token: '123456',
          date: '2024-03-08',
          patient_id: patient.id,
          doctor_id: doctor.id
        ))

        existing_test = Test.new(
          token: '123456',
          date: '2024-03-08',
          patient_id: patient.id,
          doctor_id: doctor.id
        )

        test_repo.save existing_test
      end

      expect(res).to be_a Test
      expect(res.id).to eq 1
    end
  end

  describe '#select_all' do
    it 'Retorna todos os testes do banco de dados' do
      all_tests = ConnectionService.with_pg_conn do |conn|
        patients_repo = PatientsRepository.new conn
        doctors_repo = DoctorsRepository.new conn
        tests_repo = TestsRepository.new conn

        patient1 = patients_repo.save(
          Patient.new(name: 'Fulano',
                      cpf: '000.000.000-00',
                      email: 'fulano@email.com',
                      birthdate: '1990-12-31',
                      address: 'Rua Alguma Coisa e Tal',
                      city: 'Fulanópolis',
                      state: 'Acre')
        )
        patient2 = patients_repo.save(
          Patient.new(name: 'Siclana',
                      cpf: '000.000.000-01',
                      email: 'siclana@email.com',
                      birthdate: '1990-12-31',
                      address: 'Rua Alguma Coisa e Tal',
                      city: 'Siclanópolis',
                      state: 'Acre')
        )
        doctor1 = doctors_repo.save(
          Doctor.new(name: 'Doutor Fulano',
                     email: 'dr_fulano@email.com',
                     crm: '1234567890',
                     crm_state: 'AC')
        )
        doctor2 = doctors_repo.save(
          Doctor.new(name: 'Doutora Siclana',
                     email: 'dra_siclana@email.com',
                     crm: '0987654321',
                     crm_state: 'AC')
        )

        tests_repo.save(Test.new(
          token: '123456',
          date: '2024-03-08',
          patient_id: patient1.id,
          doctor_id: doctor1.id
        ))
        tests_repo.save(Test.new(
          token: '654321',
          date: '2024-03-07',
          patient_id: patient2.id,
          doctor_id: doctor2.id
        ))

        tests_repo.select_all
      end

      expect(all_tests.count).to eq 2
      expect(all_tests[0].token).to eq '123456'
      expect(all_tests[0].patient_id).to eq 1
      expect(all_tests[1].token).to eq '654321'
      expect(all_tests[1].patient_id).to eq 2
    end

    it 'Retorna um array vazio se não existem dados na tabela' do
      res = ConnectionService.with_pg_conn do |conn|
        TestsRepository.new(conn).select_all
      end

      expect(res).to be_empty
    end
  end
end
