require 'spec_helper'

RSpec.describe 'Frontend', type: :system do
  describe 'Página de exames', js: true do
    it 'exibe elementos da home' do
      visit '/exames'


    end

    xit 'exibe dados dos exames a partir do banco', js: true do
      csv_file = File.open(File.join(__dir__, '..', 'support', 'reduced_data.csv'))
      rows = CSV.read csv_file, col_sep: ';'
      ImportJob.new.perform rows

      visit '/exames'

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
