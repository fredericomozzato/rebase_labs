require 'spec_helper'

RSpec.describe TestsService do
  describe '.get' do
    it 'Retorna dados de exames do banco de acordo com modelo esperado' do
      ImportJob.perform(file: File.open(
        File.join(__dir__, '..', 'support', 'reduced_data.csv')
      ))

      result = TestsService.get page: 1, limit: 10
      json_data = JSON.parse result
      expected_response = File.read(
        File.join(__dir__, '..', 'support', 'response_spec.json')
      )

      expect(result).not_to be_nil
      expect(json_data).to eq(JSON.parse(expected_response))
    end

    it 'Retorna dados de exames do banco de acordo com paginação' do
      ImportJob.perform(file: File.open(
        File.join(__dir__, '..', 'support', 'reduced_data.csv')
      ))

      result = TestsService.get page: 1, limit: 1
      json_data = JSON.parse result, symbolize_names: true

      expect(result).not_to be_nil
      expect(json_data).to eq([
        {"token":"T9O6AI", "date":"2021-11-21",
         "patient": {"cpf":"066.126.400-90",
                     "name":"Matheus Barroso",
                     "email":"maricela@streich.com",
                     "birthdate":"1972-03-09"},
         "doctor":  {"crm":"B000B7CDX4",
                     "crm_state":"SP",
                     "name":"Sra. Calebe Louzada"},
         "tests":  [{"type":"hemácias", "range":"45-52", "result":"48"},
                    {"type":"leucócitos", "range":"9-61", "result":"75"}]}
      ])
    end

    it 'Retorna um array vazio se não existem dados no banco' do
      res = TestsService.get page: 1, limit: 10

      json_data = JSON.parse res, symbolize_names: true
      expect(json_data).to eq []
    end
  end
end
