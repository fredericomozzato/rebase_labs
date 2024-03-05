require 'spec_helper'

RSpec.describe DbService do
  describe '.setup_test_db' do
    it 'Cria tabelas no banco relabs_test' do
      ConnectionService.with_pg_conn do |conn|
        # necessário por conta do setup do banco para cada teste
        DbService.drop_test_db

        DbService.setup_test_db
        sql = "SELECT EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests');"
        res = conn.exec sql

        expect(res.first['exists']).to eq 't'
      end
    end

    it 'Se comando não é executado tabelas não são criadas' do
      ConnectionService.with_pg_conn do |conn|
        DbService.drop_test_db

        sql = "SELECT EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests');"
        res = conn.exec sql

        expect(res.first['exists']).to eq 'f'
      end
    end
  end
end
