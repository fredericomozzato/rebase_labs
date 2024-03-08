require_relative '../services/connection_service'

class TestTypesRepository < ConnectionService
  def self.save(test_type)
    sql = <<-SQL
      INSERT INTO test_types (type, type_range, result, test_id) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING RETURNING id;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'insert_test_type', sql
      conn.exec_prepared 'insert_test_type', [test_type.type, test_type.range, test_type.result, test_type.test_id]
    end.first

    self.find_by_id res['id']
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM test_types WHERE id = $1;
    SQL

    data = with_pg_conn do |conn|
      conn.prepare 'find_test_type_by_id', sql
      conn.exec_prepared 'find_test_type_by_id', [id]
    end.first

    TestType.new(id: data['id'].to_i, type: data['type'], range: data['type_range'],
                 result: data['result'], test_id: data['test_id'])
  end

  def self.select_all
    sql = <<-SQL
      SELECT * FROM test_types;
    SQL

    res = with_pg_conn do |conn|
      conn.prepare 'select_all_types', sql
      conn.exec_prepared 'select_all_types'
    end

    res.each_row.map do |row|
      TestType.new(
        id: row[0], type: row[1], range: row[2], result: row[3], test_id: row[4]
      )
    end
  end
end
