require 'csv'
require_relative 'services/tests_service'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    puts '=== Importando dados ==='

    rows = CSV.read "./persistence/data.csv", col_sep: ';'
    TestsService.insert(rows)

    puts '=== Import concluído ==='
  end
end
