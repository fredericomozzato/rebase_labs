require 'csv'
require_relative 'services/db_service'
require_relative 'services/connection_service'
require_relative 'repositories/tests_repository'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    conn = ConnectionService.conn
    DbService.new(conn).setup
    test_repo = TestsRepository.new conn

    puts '=== Importando dados ==='

    rows = CSV.read("./persistence/data.csv", col_sep: ';')
    rows.slice(1..). each do |row|
      test_repo.insert test_data: row
    end

    conn.close
    puts '=== Import concluído ==='
  end
end
