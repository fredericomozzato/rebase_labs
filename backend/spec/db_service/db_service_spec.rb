require 'spec_helper'

RSpec.describe DbService do
  describe '.setup_test_db' do
    it 'Cria tabelas no banco relabs_test', :skip_before do
      ConnectionService.with_pg_conn do |conn|
        DbService.setup_test_db
        sql = <<-SQL
          SELECT
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'patients') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'doctors') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'test_types')
          AS tables_exists;
        SQL
        res = conn.exec sql

        expect(res.first['tables_exists']).to eq 't'
      end
    end

    it 'Se comando não é executado tabelas não são criadas', :skip_before, :skip_after do
      ConnectionService.with_pg_conn do |conn|
        sql = <<-SQL
          SELECT
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'patients') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'doctors') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'test_types')
          AS tables_exists;
        SQL
        res = conn.exec sql

        expect(res.first['tables_exists']).to eq 'f'
      end
    end
  end

  describe '.clanup_test_db' do
    it 'Remove tabelas do banco', :skip_after do
      DbService.cleanup_test_db

      ConnectionService.with_pg_conn do |conn|
        sql = <<-SQL
          SELECT
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'patients') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'doctors') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests') AND
            EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'test_types')
          AS tables_exists;
        SQL
        res = conn.exec sql

        expect(res.first['tables_exists']).to eq 'f'
      end
    end
  end
end
