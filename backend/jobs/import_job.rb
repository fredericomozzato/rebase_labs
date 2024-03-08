require 'csv'

require_relative '../models/patient'

class ImportJob
  def perform(file:)
    rows = CSV.read file_path, col_sep: ';'

    with_pg_conn do |conn|
      test_repo = TestsRepository.new conn
      rows.slice(1..).each do |row|
        # extract patient data
        patient = Patient.new(cpf: row[0], name: row[1], email: row[2], birthdate: row[3],
                              address: row[4], city: row[5], state: row[6]).save

        # extract doctor data
        doctor = Doctor.new(crm: row[7], crm_state: row[8], name: row[9], email: row[10]).save

        # extract test data
        test_data = row[11..12]

        # extract test_type data
        test_type_data = row[13..]

        # test_repo.insert test_data: row
      end
    end
  end
end
