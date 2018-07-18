require_relative 'test_helper'

class TestSqlite < Minitest::Test
  include UserTest
  include User2Test

  @setup = nil

  def setup
    super
    @setup ||= begin
                 ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
                 create_tables
                 create_dummy_data
               end
  end

  def teardown
    drop_database
  end
end
