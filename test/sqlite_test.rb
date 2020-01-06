# frozen_string_literal: true

require_relative "test_helper"

class TestSqlite < Minitest::Test
  include GemSetupTest
  include ExcpetionsTest
  include SearchTest
  include JoinTest

  def setup
    super
    @@setup ||= begin
                  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
                  create_tables
                  create_dummy_data
                  true
                end
  end
end
