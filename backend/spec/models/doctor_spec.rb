require 'spec_helper'
require_relative '../../models/doctor'

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
end
