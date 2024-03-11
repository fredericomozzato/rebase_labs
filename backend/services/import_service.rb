require_relative '../jobs/import_job'
require_relative '../lib/custom_errors'

class ImportService
  def self.import(params)
    raise CustomErrors::InvalidFileExtension.new unless params[:type] == 'text/csv'

    ImportJob.perform(file: params[:tempfile])
  end
end
