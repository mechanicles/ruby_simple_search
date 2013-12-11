require 'rspec'
require 'active_record'

ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.before(:all) do
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
    create_database
    User.create :email  => "alice@example.com",
                :name => "alice", :address => "usa",
                :contact => '12345', :age => 60
    User.create :email  => "bob@example.com",
                :name => "bob", :address => "usa",
                :contact => "56789", :age => 26
  end

  config.after(:all) do
    drop_database
  end
end

def create_database
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string :name
      t.text :address
      t.text :contact
      t.string :email
      t.integer :age
      t.timestamps
    end
  end
end

def drop_database
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
