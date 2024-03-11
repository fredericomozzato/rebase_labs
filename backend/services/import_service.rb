require_relative '../jobs/import_job'

class ImportService
  def self.import(file)
    res = ImportJob.perform(file:)
    # byebug
  end
end
