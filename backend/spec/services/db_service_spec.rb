require 'spec_helper'

RSpec.describe DbService do
  SQL = <<-SQL
    SELECT
      EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'patients') AND
      EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'doctors') AND
      EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'tests') AND
      EXISTS (SELECT tablename FROM pg_tables WHERE tablename = 'test_types')
    AS tables_exists;
  SQL

  describe '.setup_test_db' do
    it 'Cria tabelas no banco relabs_test', :skip_before do
      ConnectionService.with_pg_conn do |conn|
        DbService.setup_test_db
        res = conn.exec SQL

        expect(res.first['tables_exists']).to eq 't'
      end
    end

    it 'Se comando não é executado tabelas não são criadas', :skip_before, :skip_after do
      ConnectionService.with_pg_conn do |conn|
        res = conn.exec SQL

        expect(res.first['tables_exists']).to eq 'f'
      end
    end
  end

  describe '.cleanup_test_db' do
    it 'Remove tabelas do banco', :skip_after do
      DbService.cleanup_test_db

      ConnectionService.with_pg_conn do |conn|
        res = conn.exec SQL

        expect(res.first['tables_exists']).to eq 'f'
      end
    end
  end
end
