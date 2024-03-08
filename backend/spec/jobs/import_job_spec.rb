require 'spec_helper'

RSpec.describe ImportJob, type: :job do
  describe '.perform' do
    it 'Importa dados de arquivo CSV para o banco de dados' do
      csv_file = File.open(File.join(__dir__, '..', 'support', 'extended_data.csv'))

      ImportJob.perform file: csv_file

      expect(Patient.all.count).to eq 2
      expect(Patient.all[0].name).to eq 'Matheus Barroso'
      expect(Patient.all[1].name).to eq 'Emilly Batista Neto'
      expect(Doctor.all.count).to eq 2
      expect(Doctor.all[0].name).to eq 'Sra. Calebe Louzada'
      expect(Doctor.all[1].name).to eq 'Maria Luiza Pires'
      expect(Test.all.count).to eq 2
      expect(Test.all[0].token).to eq 'T9O6AI'
      expect(Test.all[1].token).to eq 'IQCZ17'
      expect(TestType.all.count).to eq 26
    end
  end
end
