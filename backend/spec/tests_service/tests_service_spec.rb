require 'spec_helper'

RSpec.describe TestsService do
  describe '.csv_insert' do
    it 'Insere dados de arquivo CSV no banco' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      ConnectionService.with_pg_conn do |conn|
        res = conn.exec 'SELECT * FROM tests;'
        expect(res).not_to be_nil
        expect(res.first).to eq({"id"=>"1",
                                 "patient_cpf"=>"048.973.170-88",
                                 "patient_name"=>"Emilly Batista Neto",
                                 "patient_email"=>"gerald.crona@ebert-quigley.com",
                                 "patient_birthdate"=>"2001-03-11",
                                 "patient_address"=>"165 Rua Rafaela",
                                 "patient_city"=>"Ituverava",
                                 "patient_state"=>"Alagoas",
                                 "doctor_crm"=>"B000BJ20J4",
                                 "doctor_crm_state"=>"PI",
                                 "doctor_name"=>"Maria Luiza Pires",
                                 "doctor_email"=>"denna@wisozk.biz",
                                 "test_result_token"=>"IQCZ17",
                                 "test_date"=>"2021-08-05",
                                 "test_type"=>"hemácias",
                                 "test_type_range"=>"45-52",
                                 "test_result"=>"97"})
      end
    end
  end

  describe '.get' do
    it 'Retorna dados de exames do banco como um array JSON' do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      result = TestsService.get
      json_data = JSON.parse result

      expect(result).not_to be_nil
      expect(json_data).to eq("tests"=> [
        { "id"=>"1",
          "patient_cpf"=>"048.973.170-88",
          "patient_name"=>"Emilly Batista Neto",
          "patient_email"=>"gerald.crona@ebert-quigley.com",
          "patient_birthdate"=>"2001-03-11",
          "patient_address"=>"165 Rua Rafaela",
          "patient_city"=>"Ituverava",
          "patient_state"=>"Alagoas",
          "doctor_crm"=>"B000BJ20J4",
          "doctor_crm_state"=>"PI",
          "doctor_name"=>"Maria Luiza Pires",
          "doctor_email"=>"denna@wisozk.biz",
          "test_result_token"=>"IQCZ17",
          "test_date"=>"2021-08-05",
          "test_type"=>"hemácias",
          "test_type_range"=>"45-52",
          "test_result"=>"97" }
        ])
    end

    it 'Retorna um array vazio se não existem dados no banco' do
      res = TestsService.get

      json_data = JSON.parse res, symbolize_names: true
      expect(json_data).to eq({ tests: [] })
    end
  end
end
