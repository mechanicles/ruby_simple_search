require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require 'active_record'
require_relative "../lib/ruby_simple_search.rb"

Minitest::Test = Minitest::Unit::TestCase unless defined?(Minitest::Test)

class Minitest::Test

  def before_setup
    super
    ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                            database: ":memory:")
    create_database

    User.create email: "alice@example.com",
                name: "alice",
                address: "usa",
                contact: '12345',
                age: 60,
                username: 'alicestar'


    User.create email: "bob@example.com",
                name: "bob",
                address: "india",
                contact: "56789",
                age: 26,
                username: 'rockstar'

    User.create email: "bob@something.com",
                name: "bob",
                address: "uk",
                contact: "45786",
                age: 21,
                username: 'kingkhan'
  end

  def after_teardown
    super
    drop_database
  end

  private

  def create_database
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Migration.create_table :users, force: true do |t|
      t.string :name
      t.text :address
      t.text :contact
      t.string :email
      t.integer :age
      t.string :username
      t.timestamps
    end
  end

  def drop_database
    ActiveRecord::Migration.verbose = false

    if ActiveRecord::Migration.table_exists?(:users)
      ActiveRecord::Migration.drop_table(:users)
    end
  end

end

class User < ActiveRecord::Base

  include RubySimpleSearch

  simple_search_attributes :name, :email, :contact, :address

end

class User2 < ActiveRecord::Base

  include RubySimpleSearch

end
