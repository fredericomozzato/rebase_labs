require 'csv'
require_relative 'services/db_service'
require_relative 'services/connection_service'
require_relative 'repositories/tests_repository'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    puts '=== Importando dados ==='

    ConnectionService.with_pg_conn do |conn|
      DbService.setup conn
      test_repo = TestsRepository.new conn

      rows = CSV.read("./persistence/data.csv", col_sep: ';')

      rows.slice(1..). each do |row|
        test_repo.insert test_data: row
      end
    end

    puts '=== Import concluído ==='
  end
end
