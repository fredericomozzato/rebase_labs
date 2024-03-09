require 'spec_helper'

RSpec.describe ImportJob, type: :job do
  describe '.perform' do
    it 'Importa dados de arquivo CSV para o banco de dados' do
      csv_file = File.open(File.join(__dir__, '..', 'support', 'extended_data.csv'))

      ImportJob.perform file: csv_file

      ConnectionService.with_pg_conn do |conn|
        patients = PatientsRepository.new(conn).select_all
        doctors = DoctorsRepository.new(conn).select_all
        tests = TestsRepository.new(conn).select_all
        test_types = TestTypesRepository.new(conn).select_all

        expect(patients.count).to eq 2
        expect(patients[0].name).to eq 'Matheus Barroso'
        expect(patients[1].name).to eq 'Emilly Batista Neto'
        expect(doctors.count).to eq 2
        expect(doctors[0].name).to eq 'Sra. Calebe Louzada'
        expect(doctors[1].name).to eq 'Maria Luiza Pires'
        expect(tests.count).to eq 2
        expect(tests[0].token).to eq 'T9O6AI'
        expect(tests[1].token).to eq 'IQCZ17'
        expect(test_types.count).to eq 26
      end
    end
  end
end
