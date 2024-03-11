require 'csv'
require_relative '../jobs/import_job'
require_relative '../lib/custom_errors'

class ImportService
  def self.import(params)
    validate_params params

    rows = CSV.read params[:tempfile], col_sep: ';', skip_blanks: true

    ImportJob.perform_async(rows)
  end

  def self.validate_params(params)
    raise CustomErrors::InvalidFileExtension.new unless params[:type] == 'text/csv'

    expected_headers = [
      "cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame"
    ]
    actual_headers = CSV.read(params[:tempfile], headers: true).headers

    raise CustomErrors::InvalidCsvHeader.new unless actual_headers == expected_headers
  end
  private_class_method :validate_params
end
