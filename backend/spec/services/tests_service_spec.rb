require 'spec_helper'

RSpec.describe TestsService do
  describe '.get' do
    it 'Retorna dados de exames do banco de acordo com modelo esperado' do
      ImportJob.perform(file: File.open(
        File.join(__dir__, '..', 'support', 'reduced_data.csv')
      ))

      result = TestsService.get page: 1, limit: 1
      json_data = JSON.parse result
      expected_response = File.read(
        File.join(__dir__, '..', 'support', 'response_spec.json')
      )

      expect(result).not_to be_nil
      expect(json_data).to eq(JSON.parse(expected_response))
    end

    xit 'Retorna dados de exames do banco de acordo com paginação' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      result = TestsService.get page: 2, limit: 1
      json_data = JSON.parse result

      expect(result).not_to be_nil
      expect(json_data).to eq("tests"=> [
        { "id"=>"2",
          "patient_cpf"=>"048.108.026-04",
          "patient_name"=>"Juliana dos Reis Filho",
          "patient_email"=>"mariana_crist@kutch-torp.com",
          "patient_birthdate"=>"1995-07-03",
          "patient_address"=>"527 Rodovia Júlio",
          "patient_city"=>"Lagoa da Canoa",
          "patient_state"=>"Paraíba",
          "doctor_crm"=>"B0002IQM66",
          "doctor_crm_state"=>"SC",
          "doctor_name"=>"Maria Helena Ramalho",
          "doctor_email"=>"rayford@kemmer-kunze.info",
          "test_result_token"=>"0W9I67",
          "test_date"=>"2021-07-09",
          "test_type"=>"vldl",
          "test_type_range"=>"48-72",
          "test_result"=>"41" }
        ])
    end

    xit 'Retorna um array vazio se não existem dados no banco' do
      res = TestsService.get page: 1, limit: 10

      json_data = JSON.parse res, symbolize_names: true
      expect(json_data).to eq({ tests: [] })
    end
  end
end