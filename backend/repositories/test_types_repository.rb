require_relative '../services/connection_service'

class TestTypesRepository < ConnectionService
  def self.save(test_type)
    sql = <<-SQL
      INSERT INTO test_types (type, type_range, result, test_id) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING RETURNING id;
    SQL

    res = with_pg_conn do |conn|
      conn.exec sql, [test_type.type, test_type.range, test_type.result, test_type.test_id]
    end.first

    self.find_by_id res['id']
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM test_types WHERE id = $1;
    SQL

    data = with_pg_conn do |conn|
      conn.exec sql, [id]
    end.first

    TestType.new(id: data['id'].to_i, type: data['type'], range: data['type_range'],
                 result: data['result'], test_id: data['test_id'])
  end
end
