require_relative 'test_helper'
require 'active_record/connection_adapters/mysql2_adapter'

class MysqlTest < Minitest::Test
  include GemSetupTest
  include ExcpetionsTest
  include SearchTest
  include JoinTest

  def setup
    super
    @@setup ||= begin
                  ActiveRecord::Base.establish_connection adapter: 'mysql2', database: 'ruby_simple_search_test', username: 'root'
                  create_tables
                  create_dummy_data
                  true
                end
  end
end
