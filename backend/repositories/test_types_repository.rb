require_relative '../services/connection_service'

class TestTypesRepository
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def save(test_type)
    sql = <<-SQL
      INSERT INTO test_types (type, type_range, result, test_id) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING RETURNING id;
    SQL

    res = @conn.exec(
      sql, [test_type.type, test_type.range, test_type.result, test_type.test_id]
    ).first

    find_by_id res['id']
  end

  def find_by_id(id)
    sql = <<-SQL
      SELECT * FROM test_types WHERE id = $1;
    SQL

    data = @conn.exec(sql, [id]).first

    TestType.new(id: data['id'].to_i, type: data['type'], range: data['type_range'],
                 result: data['result'], test_id: data['test_id'])
  end

  def select_all
    sql = <<-SQL
      SELECT * FROM test_types;
    SQL

    res = @conn.exec sql

    res.each_row.map do |row|
      TestType.new(
        id: row[0], type: row[1], range: row[2], result: row[3], test_id: row[4]
      )
    end
  end
end
