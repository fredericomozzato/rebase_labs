require 'spec_helper'

RSpec.describe Doctor, type: :model do
  describe '#save' do
    it 'Salva médico no banco de dados caso este não exista' do
      doctor = Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'AC'
      )

      res = doctor.save

      expect(res).to be_a Doctor
      expect(res.id).to eq 1
    end

    it 'Retorna médico caso este já esteja salvo no banco' do
      Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'AC'
      ).save

      existing_doctor = Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'AC'
      )
      res = existing_doctor.save

      expect(res).to be_a Doctor
      expect(res.id).to eq 1
    end
  end

  describe '.all' do
    it 'Retorna todos os médicos salvos no banco' do
      d1 = Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'SP'
      ).save
      d2 = Doctor.new(
        name: 'Doutora Siclana',
        email: 'dra_siclana@email.com',
        crm: '0987654321',
        crm_state: 'RS'
      ).save

      all_doctors = Doctor.all

      expect(all_doctors.count).to eq 2
      expect(all_doctors[0].id).to eq 1
      expect(all_doctors[0].name).to eq 'Doutor Fulano'
      expect(all_doctors[1].id).to eq 2
      expect(all_doctors[1].name).to eq 'Doutora Siclana'
    end

    it 'Retorna um array vazio se não existem dados na tabela' do
      expect(Doctor.all).to be_empty
    end
  end
end
