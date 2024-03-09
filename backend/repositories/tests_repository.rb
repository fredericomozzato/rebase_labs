require_relative '../services/connection_service'

class TestsRepository
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def save(test)
    sql = <<-SQL
      INSERT INTO tests (token, date, patient_id, doctor_id) VALUES
      ($1, $2, $3, $4) ON CONFLICT DO NOTHING;
    SQL

    @conn.exec sql, [test.token, test.date, test.patient_id, test.doctor_id]

    find_by_token test.token
  end

  def find_by_token(token)
    sql = <<-SQL
      SELECT * FROM tests WHERE token = $1;
    SQL

    data = @conn.exec(sql, [token]).first

    Test.new(id: data['id'].to_i, token: data['token'], date: data['date'],
             patient_id: data['patient_id'], doctor_id: data['doctor_id'])
  end

  def select_all
    sql = <<-SQL
      SELECT * FROM tests;
    SQL

    res = @conn.exec sql

    res.each_row.map do |row|
      Test.new(id: row[0], token: row[1], date: row[2], patient_id: row[3], doctor_id: row[4])
    end
  end

  def select_paginated(offset:, limit:)
    sql = <<-SQL
      SELECT * from tests OFFSET $1 LIMIT $2;
    SQL

    @conn.exec(sql, [offset, limit]).each_row.map do |row|
      Test.new(id: row[0], token: row[1], date: row[2], patient_id: row[3], doctor_id: row[4])
    end
  end
end
