require 'spec_helper'

RSpec.describe ImportService do
  describe '#import' do
    it 'Chama ImportJob de forma assíncrona' do
      csv_file = File.open(File.join(__dir__, '..', 'support', 'reduced_data.csv'))
      params = {type: 'text/csv',
                tempfile: Rack::Test::UploadedFile.new(csv_file, 'text/csv')}
      import_job_spy = spy ImportJob
      stub_const 'ImportJob', import_job_spy

      ImportService.import params

      expect(import_job_spy).to have_received(:perform_async).once
    end

    it 'Levanta exceção caso arquivo não tenha o cabeçalho correto' do
      bad_csv_file = File.open(File.join(__dir__, '..', 'support', 'bad_file.csv'))
      params = {type: 'text/csv',
                tempfile: Rack::Test::UploadedFile.new(bad_csv_file, 'text/csv')}

      expect { ImportService.import(params) }.to raise_error CustomErrors::InvalidCsvHeader
    end
  end
end
