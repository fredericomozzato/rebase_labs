require_relative '../jobs/import_job'

class ImportService
  def self.import(file)
    debugger
    res = ImportJob.perform(file:)
  end
end
