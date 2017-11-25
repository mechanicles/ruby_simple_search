require_relative "test_helper"

class PostgresqlTest < Minitest::Test
  include UserTest
  include User2Test

  def setup
    super
    @@setup ||= begin
                  ActiveRecord::Base.establish_connection adapter: "postgresql", database: "ruby_simple_serach_test"
                  create_tables
                  create_dummy_data
                end
  end

end
