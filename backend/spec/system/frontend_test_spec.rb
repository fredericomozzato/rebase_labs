require 'spec_helper'

RSpec.describe 'Frontend', type: :system do
  describe 'Página de exames', js: true do
    it 'exibe tabela' do
      visit '/exames'

      expect(page).to have_content 'Tabela de exames'
      within 'table' do
        expect(page).to have_content 'Paciente'
        expect(page).to have_content 'CPF'
        expect(page).to have_content 'Exame'
        expect(page).to have_content 'Nome', count: 2
        expect(page).to have_content 'E-mail', count: 2
        expect(page).to have_content 'Nascimento'
        expect(page).to have_content 'Endereço'
        expect(page).to have_content 'Cidade'
        expect(page).to have_content 'Estado'
        expect(page).to have_content 'CRM'
        expect(page).to have_content 'Estado do CRM'
        expect(page).to have_content 'Token'
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Tipo'
        expect(page).to have_content 'Intervalo'
        expect(page).to have_content 'Resultado'
      end
    end

    it 'exibe dados dos exames a partir do banco', js: true do
      TestsService.csv_insert file_path: File.join(__dir__, '..', 'support', 'reduced_data.csv')

      # puts "\n\n\n#{ENV['RACK_ENV']}\n\n\n"


      visit '/exames'

      # byebug

      expect(page).to have_current_path 'http://frontend:3000/exames'
      within 'table' do
        expect(page).to have_content '048.973.170-88'
        expect(page).to have_content 'Emilly Batista Neto'
        expect(page).to have_content 'gerald.crona@ebert-quigley.com'
        expect(page).to have_content '11/03/2001'
        expect(page).to have_content '165 Rua Rafaela'
        expect(page).to have_content 'Ituverava'
        expect(page).to have_content 'Alagoas'
        expect(page).to have_content 'B000BJ20J4'
        expect(page).to have_content 'PI'
        expect(page).to have_content 'Maria Luiza Pires'
        expect(page).to have_content 'denna@wisozk.biz'
        expect(page).to have_content 'IQCZ17'
        expect(page).to have_content '05/08/2021'
        expect(page).to have_content 'hemácias'
        expect(page).to have_content '45-52'
        expect(page).to have_content '97'
      end
    end
  end
end
