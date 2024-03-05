require 'spec_helper'

RSpec.describe DbService do
  describe '.setup_test_db' do
    it 'Cria tabelas no banco relabs_test', :skip_before do
      ConnectionService.with_pg_conn do |conn|
        DbService.setup_test_db
        sql = "SELECT EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests');"
        res = conn.exec sql

        expect(res.first['exists']).to eq 't'
      end
    end

    it 'Se comando não é executado tabelas não são criadas', :skip_before, :skip_after do
      ConnectionService.with_pg_conn do |conn|
        sql = "SELECT EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests');"
        res = conn.exec sql

        expect(res.first['exists']).to eq 'f'
      end
    end
  end

  describe '.drop_test_db' do
    it 'Remove tabelas do banco', :skip_after do
      DbService.drop_test_db

      ConnectionService.with_pg_conn do |conn|
        sql = "SELECT EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests');"
        res = conn.exec sql

        expect(res.first['exists']).to eq 'f'
      end
    end
  end
end
