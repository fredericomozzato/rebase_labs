require 'csv'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    puts '=== Importando dados ==='

    rows = CSV.read("./persistence/data.csv", col_sep: ';')
    columns = rows.shift
    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end

    puts '=== Import concluído ==='
  end
end
