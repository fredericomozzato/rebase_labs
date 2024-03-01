require 'csv'
require_relative 'services/db_service'

desc 'Importar dados de exames de data.csv'

namespace :data do
  task :import do
    DbService.new.setup

    puts '=== Importando dados ==='

    rows = CSV.read("./persistence/reduced_data.csv", col_sep: ';')
    p rows.slice(1..). each do |row|

    end

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
