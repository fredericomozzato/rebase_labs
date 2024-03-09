require 'spec_helper'
require_relative '../../repositories/patients_repository'

RSpec.describe PatientsRepository do
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

      res = ConnectionService.with_pg_conn do |conn|
        PatientsRepository.new(conn).save patient
      end

      expect(res).to be_a Patient
      expect(res.id).to eq(1)
    end

    it 'Retorna paciente caso este já esteja salvo no banco' do
      patient = Patient.new(
                  name: 'Fulano',
                  cpf: '000.000.000-00',
                  email: 'fulano@email.com',
                  birthdate: '1990-12-31',
                  address: 'Rua Alguma Coisa e Tal',
                  city: 'Fulanópolis',
                  state: 'Acre'
                )
      existing_patient = Patient.new(
        name: 'Fulano',
        cpf: '000.000.000-00',
        email: 'fulano@email.com',
        birthdate: '1990-12-31',
        address: 'Rua Alguma Coisa e Tal',
        city: 'Fulanópolis',
        state: 'Acre'
      )
      res = ConnectionService.with_pg_conn do |conn|
        repo = PatientsRepository.new conn
        repo.save patient

        repo.save existing_patient
      end

      expect(res).to be_a Patient
      expect(res.id).to eq 1
    end
  end

  describe '#select_all' do
    it 'Retorna todos os pacientes salvos no banco' do
      p1 = Patient.new(name: 'Fulano', cpf: '000.000.000-00', email: 'fulano@email.com',
                       birthdate: '1999-05-28', address: 'Rua um, N19', city: 'São Paulo',
                       state: 'São Paulo')
      p2 = Patient.new(name: 'Siclana', cpf: '000.000.000-01', email: 'siclana@email.com',
                       birthdate: '1997-12-21', address: 'Rua Dois, N25', city: 'Porto Alegre',
                       state: 'Rio Grande do Sul')

      all_patients = ConnectionService.with_pg_conn do |conn|
        repo = PatientsRepository.new conn
        repo.save p1
        repo.save p2
        repo.select_all
      end

      expect(all_patients.count).to eq 2
      expect(all_patients[0].name).to eq 'Fulano'
      expect(all_patients[0].id).to eq 1
      expect(all_patients[1].name).to eq 'Siclana'
      expect(all_patients[1].id).to eq 2
    end

    it 'Retorna um array vazio se não existem dados no banco' do
      res = ConnectionService.with_pg_conn do |conn|
        PatientsRepository.new(conn).select_all
      end

      expect(res).to be_empty
    end
  end
end
