require_relative 'test_helper'

class PostgresqlTest < Minitest::Test
  include GemSetupTest
  include ExcpetionsTest
  include SearchTest
  include JoinTest

  def setup
    super
    @@setup ||= begin
                  ActiveRecord::Base.establish_connection adapter: 'postgresql', database: 'ruby_simple_search_test'
                  create_tables
                  create_dummy_data
                  true
                end
  end
end
