require 'spec_helper'

RSpec.describe DoctorsRepository do
  describe '#save' do
    it 'Salva médico no banco de dados' do
      doctor = Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'AC'
      )

      res = ConnectionService.with_pg_conn do |conn|
        DoctorsRepository.new(conn).save doctor
      end

      expect(res).to be_a Doctor
      expect(res.id).to eq 1
    end

    it 'Retorna médico caso este já esteja salvo no banco' do
      doctor = Doctor.new(
                name: 'Doutor Fulano',
                email: 'dr_fulano@email.com',
                crm: '1234567890',
                crm_state: 'AC'
              )

      existing_doctor = Doctor.new(
                          name: 'Doutor Fulano',
                          email: 'dr_fulano@email.com',
                          crm: '1234567890',
                          crm_state: 'AC'
                        )

      res = ConnectionService.with_pg_conn do |conn|
        repo = DoctorsRepository.new conn
        repo.save doctor
        repo.save existing_doctor
      end

      expect(res).to be_a Doctor
      expect(res.id).to eq 1
    end
  end

  describe '#select_all' do
    it 'Retorna todos os médicos salvos no banco' do
      d1 = Doctor.new(
        name: 'Doutor Fulano',
        email: 'dr_fulano@email.com',
        crm: '1234567890',
        crm_state: 'SP'
      )
      d2 = Doctor.new(
        name: 'Doutora Siclana',
        email: 'dra_siclana@email.com',
        crm: '0987654321',
        crm_state: 'RS'
      )

      all_doctors = ConnectionService.with_pg_conn do |conn|
        repo = DoctorsRepository.new conn
        repo.save d1
        repo.save d2
        repo.select_all
      end

      expect(all_doctors.count).to eq 2
      expect(all_doctors[0].id).to eq 1
      expect(all_doctors[0].name).to eq 'Doutor Fulano'
      expect(all_doctors[1].id).to eq 2
      expect(all_doctors[1].name).to eq 'Doutora Siclana'
    end

    it 'Retorna um array vazio se não existem dados na tabela' do
      res = ConnectionService.with_pg_conn do |conn|
        DoctorsRepository.new(conn).select_all
      end

      expect(res).to be_empty
    end
  end
end
