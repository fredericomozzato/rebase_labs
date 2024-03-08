require 'csv'

require_relative '../models/patient'

class ImportJob
  def perform(file:)
    rows = CSV.read file_path, col_sep: ';'

    with_pg_conn do |conn|
      test_repo = TestsRepository.new conn
      rows.slice(1..).each do |row|
        # extract patient data
        patient_data = row[0..6]
        patient = Patient.new(cpf: row[0], name: row[1], email: row[2], birthdate: row[3],
                              address: row[4], city: row[5], state: row[6])


        # extact doctor data
        doctor_data = row[7..10]

        # extract test data
        test_data = row[11..12]

        # extract test_type data
        test_type_data = row[13..]

        # test_repo.insert test_data: row
      end
    end
  end
end
