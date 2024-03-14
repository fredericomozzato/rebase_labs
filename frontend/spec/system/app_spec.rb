require 'spec_helper'

RSpec.describe 'App', type: :system do
  describe 'Usuário vê exames na página inicial', js: true do
    it 'quando não existem exames cadastrados no banco da API' do
      allow(ApiService).to receive(:select_all).and_return '[]'

      visit '/exames'

      expect(page).to have_content 'Nenhum exame encontrado'
    end

    it 'com sucesso' do
      fake_json = File.read(File.join(__dir__, '..', 'support', 'api_response.json'))
      allow(ApiService).to receive(:select_all).and_return fake_json

      visit '/exames'

      expect(page).to have_content 'Exames'
      within('#tests-list') do
        expect(page).to have_content 'T9O6AI'
        expect(page).to have_content '21/11/2021'
        expect(page).to have_content 'Matheus Barroso'
        expect(page).to have_content 'Sra. Calebe Louzada'
        expect(page).to have_content 'IQCZ17'
        expect(page).to have_content '05/08/2021'
        expect(page).to have_content 'Emilly Batista Neto'
        expect(page).to have_content 'Maria Luiza Pires'
        expect(page).to have_selector 'a', text: 'Detalhes', count: 2
      end
    end
  end

  describe 'Usuário vê detalhes de um exame' do
    context 'com sucesso' do
      it 'clicando no botão "Detalhes" do card' do
        fake_json = File.read(File.join(__dir__, '..', 'support', 'api_response.json'))
        fake_test_json = File.read(File.join(__dir__, '..', 'support', 'fake_test.json'))
        allow(ApiService).to receive(:select_all).and_return fake_json

        visit '/exames'

        allow(ApiService).to receive(:search). with(token: 'T9O6AI').and_return fake_test_json
        first('a', text: 'Detalhes').click

        expect(page).to have_content 'Exame: T9O6AI'
        expect(page).to have_content 'Paciente'
        expect(page).to have_content 'Matheus Barroso'
        expect(page).to have_content 'maricela@streich.com'
        expect(page).to have_content '09/03/1972'
        expect(page).to have_content 'Médico'
        expect(page).to have_content 'Sra. Calebe Louzada'
        expect(page).to have_content 'B000B7CDX4/SP'
        expect(page).to have_content 'Resultados'
        expect(page).to have_selector 'a', text: '← Voltar'
        within 'table' do
          within 'thead' do
            expect(page).to have_content 'Tipo'
            expect(page).to have_content 'Intervalo'
            expect(page).to have_content 'Resultado'
          end
          within 'tbody' do
            expect(page).to have_content 'hemácias'
            expect(page).to have_content '45-52'
            expect(page).to have_content '48'
            expect(page).to have_content 'leucócitos'
            expect(page).to have_content '9-61'
            expect(page).to have_content '75'
          end
        end
      end

      it 'pesquisando pelo token no campo de busca' do
        fake_test_json = File.read(File.join(__dir__, '..', 'support', 'fake_test.json'))
        allow(ApiService).to receive(:search).with(token: 'T9O6AI').and_return fake_test_json

        visit '/exames'
        within 'nav' do
          field = find('#search-field')
          field.fill_in with: 'T9O6AI'
          find('#search-btn').click
        end

        expect(page).to have_content 'Exame: T9O6AI'
        expect(page).to have_content 'Paciente'
        expect(page).to have_content 'Matheus Barroso'
        expect(page).to have_content 'maricela@streich.com'
        expect(page).to have_content '09/03/1972'
        expect(page).to have_content 'Médico'
        expect(page).to have_content 'Sra. Calebe Louzada'
        expect(page).to have_content 'B000B7CDX4/SP'
        expect(page).to have_content 'Resultados'
        expect(page).to have_selector 'a', text: '← Voltar'
        within 'table' do
          within 'thead' do
            expect(page).to have_content 'Tipo'
            expect(page).to have_content 'Intervalo'
            expect(page).to have_content 'Resultado'
          end
          within 'tbody' do
            expect(page).to have_content 'hemácias'
            expect(page).to have_content '45-52'
            expect(page).to have_content '48'
            expect(page).to have_content 'leucócitos'
            expect(page).to have_content '9-61'
            expect(page).to have_content '75'
          end
        end
      end
    end

    context 'sem sucesso' do
      it 'pesquisando por um token inválido' do
        visit '/exames'
        within 'nav' do
          field = find('#search-field')
          field.fill_in with: '000000'
          find('#search-btn').click
        end

        expect(page).to have_content 'Nenhum exame encontrado com o token 000000'
        expect(page).to have_content 'Confira o token ou importe novos exames usando o botão no menu'
        expect(page).to have_selector 'a', text: 'Voltar'
      end
    end
  end

  describe 'Usuário faz upload de arquivo' do
    it 'com sucesso' do
      allow(ApiService).to receive(:select_all).and_return '[]'
      visit '/exames'
      within '#search-form' do
        find('#import-btn').click
      end
      attach_file 'file', '/app/spec/support/reduced_data.csv'
      find('button', text: 'Enviar').click

      expect(page).to have_content 'Seu upload está sendo processado'
    end

    it 'sem sucesso com arquivo incompatível' do
      allow(ApiService).to receive(:select_all).and_return '[]'
      visit '/exames'
      within '#search-form' do
        find('#import-btn').click
      end
      attach_file 'file', '/app/spec/support/bad_file.csv'
      find('button', text: 'Enviar').click

      expect(page).to have_content 'Erro. Arquivo não pode ser processado'
    end
  end
end
