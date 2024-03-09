require 'spec_helper'

RSpec.describe TestTypesRepository do
  describe '#save' do
    it 'Salva tipo de teste no banco caso este não exista' do
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
        test_type = TestTypesRepository.new(conn).save(
          TestType.new(type: 'plaquetas',
                       range: '48-72',
                       result: 69,
                       test_id: test.id)
        )
      end

      expect(res).to be_a TestType
      expect(res.id).to eq 1
    end
  end

  describe '#select_all' do
    it 'Retorna todos os tipos de teste do banco de dados' do
      all_types = ConnectionService.with_pg_conn do |conn|
        patients_repo = PatientsRepository.new conn
        doctors_repo = DoctorsRepository.new conn
        tests_repo = TestsRepository.new conn
        test_types_repo = TestTypesRepository.new conn

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
        test1 = tests_repo.save(
          Test.new(token: '123456',
                    date: '2024-03-08',
                    patient_id: patient1.id,
                    doctor_id: doctor1.id)
        )
        test2 = tests_repo.save(
          Test.new(token: '654321',
                   date: '2024-03-07',
                   patient_id: patient2.id,
                   doctor_id: doctor2.id)
        )
        test_type1 = test_types_repo.save(
          TestType.new(type: 'plaquetas',
                       range: '18-99',
                       result: 50,
                       test_id: 1)
        )
        test_type2 = test_types_repo.save(
          TestType.new(type: 'hemácias',
                       range: '34-128',
                       result: 99,
                       test_id: 1)
        )
        test_type3 = test_types_repo.save(
          TestType.new(type: 'glicose',
                       range: '48-70',
                       result: 89,
                       test_id: 2)
        )
        test_type4 = test_types_repo.save(
          TestType.new(type: 'leucócitos',
                       range: '10-90',
                       result: 34,
                       test_id: 2)
        )

        test_types_repo.select_all
      end

      expect(all_types.count).to eq 4
      expect(all_types[0].type).to eq 'plaquetas'
      expect(all_types[0].test_id).to eq 1
      expect(all_types[1].type).to eq 'hemácias'
      expect(all_types[1].test_id).to eq 1
      expect(all_types[2].type).to eq 'glicose'
      expect(all_types[2].test_id).to eq 2
      expect(all_types[3].type).to eq 'leucócitos'
      expect(all_types[3].test_id).to eq 2
    end

    it 'Retorna um array vazio se não existem dados na tabela' do
      res = ConnectionService.with_pg_conn do |conn|
        TestTypesRepository.new(conn).select_all
      end

      expect(res).to be_empty
    end
  end
end
