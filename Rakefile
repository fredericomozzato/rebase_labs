require_relative 'services/tests_service'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    puts '=== Importando dados ==='

    TestsService.csv_insert(file_path: "./persistence/data.csv")

    puts '=== Import concluído ==='
  end
end
