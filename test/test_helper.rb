require 'bundler/setup'
Bundler.require(:default)
require 'minitest/autorun'
require 'minitest/pride'
require 'logger'
require 'active_record'

Minitest::Test = Minitest::Unit::TestCase unless defined?(Minitest::Test)

class User < ActiveRecord::Base
  include RubySimpleSearch
  has_many :posts

  simple_search_attributes :name, :email, :contact, :address
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class User2 < ActiveRecord::Base
  include RubySimpleSearch
end

# migration
def create_tables
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Migration.create_table :users, force: true do |t|
    t.string :name, null: false
    t.text :address
    t.text :contact
    t.string :email
    t.integer :age
    t.string :username
    t.timestamps
  end

  ActiveRecord::Migration.create_table :posts, force: true do |t|
    t.string :name, null: false
    t.references :user
    t.timestamps
  end
end

def create_dummy_data
  alice = User.create! email: 'alice@example.com',
    name: "alice",
    address: 'usa',
    contact: '12345',
    age: 60,
    username: 'alicestar'

  User.create! email: 'bob@example.com',
    name: "bob",
    address: 'india',
    contact: '56789',
    age: 26,
    username: 'rockstar'

  User.create! email: 'bob@something.com',
    name: "bob",
    address: 'uk',
    contact: '45786',
    age: 21,
    username: 'kingkhan'

  Post.create! name: 'Ruby is simple', user: alice
end

def drop_database
  ActiveRecord::Migration.verbose = false

  if ActiveRecord::Migration.table_exists?(:users)
    ActiveRecord::Migration.drop_table(:users)
  end
end

module UserTest
  # Test initial setup gets set properly

  def test_no_exception_is_raised_if_simple_search_attributes_is_called_in_the_model
    # This will just make sure that internal variables for RubySimpleSearch
    # get set properly.

    assert_silent { User.simple_search('USA') }
  end

  def test_it_sets_attributes_properly
    User.simple_search_attributes :name, :email, :contact, :address

    assert_equal %i[name email contact address], User.instance_variable_get('@simple_search_attributes')
  end

  def test_it_has_default_like_pattern
    User.simple_search('Alice')

    assert_equal '%q%', User.instance_variable_get('@simple_search_pattern')
  end

  def test_it_can_have_patterns_like_plain_beginning_ending_containing_and_underscore
    User.simple_search('alice', pattern: :plain)
    assert_equal 'q', User.instance_variable_get('@simple_search_pattern')

    User.simple_search('al', pattern: :beginning)
    assert_equal 'q%', User.instance_variable_get('@simple_search_pattern')
    User.simple_search('alice', pattern: :ending)
    assert_equal '%q', User.instance_variable_get('@simple_search_pattern')

    User.simple_search('alice', pattern: :containing)
    assert_equal '%q%', User.instance_variable_get('@simple_search_pattern')

    User.simple_search('alice', pattern: :underscore)
    assert_equal '_q_', User.instance_variable_get('@simple_search_pattern')
  end

  def test_it_searches_the_users_whose_names_are_alice
    user  = User.find_by_name('alice')
    users = User.simple_search('alice')

    assert_includes users, user
  end

  def test_it_raises_an_exception_if_pattern_is_wrong
    error = assert_raises(RuntimeError) do
      User.simple_search('alice', pattern: 'wrong')
    end

    assert_equal RubySimpleSearch::Errors::INVALID_PATTERN, error.message
  end

  def test_it_searches_the_users_whose_names_are_alice_with_beginning_pattern
    user  = User.find_by_name('alice')
    users = User.simple_search('al', pattern: :beginning)

    assert_includes users, user
  end

  def test_it_returns_empty_users_if_pattern_is_beginning_but_query_has_non_beginning_characters
    users = User.simple_search('ce', pattern: :beginning)

    assert_empty users
  end

  def test_it_returns_empty_records_if_contact_number_does_not_exist
    users = User.simple_search('343434')

    assert_empty users
  end

  def test_it_searches_user_records_if_users_belong_to_usa
    users          = User.where(address: 'usa')
    searched_users = User.simple_search('USA')

    assert_equal users.pluck(:id), searched_users.pluck(:id)
  end

  def test_it_searches_the_records_with_beginning_pattern
    users = User.where('name like ?', 'bo%')

    searched_users = User.simple_search('bo', pattern: :beginning)

    assert_equal searched_users.count, users.count
  end

  def test_searches_the_records_with_ending_pattern
    users = User.where('name like ?', '%ce')

    searched_users = User.simple_search('ce', pattern: :ending)

    assert_equal searched_users.count, users.count
  end

  def test_searches_the_records_with_underscore_pattern
    users = User.where('name like ?', 'ce')

    searched_users = User.simple_search('ce', pattern: :underscore)

    assert_equal searched_users.count, users.count
  end

  def test_searches_the_records_with_plain_pattern
    users = User.where('name like ?', 'bob')

    searched_users = User.simple_search('bob', pattern: :plain)

    assert_equal searched_users.count, users.count
  end

  def test_returns_users_who_live_in_the_usa_and_their_age_is_greater_than_50
    User.simple_search_attributes :name, :contact, :address

    searched_users = User.simple_search('usa', pattern: :plain) do
      ['AND age > ?', 50]
    end

    assert_equal searched_users.pluck(:address), ['usa']
    assert_equal searched_users.pluck(:age), [60]
  end

  def test_returns_an_exception_if_array_condition_is_wrong_in_simple_search_block
    error = assert_raises(RuntimeError) do
      User.simple_search('usa') do
        ['AND age > ?', 50, 60]
      end
    end

    assert_equal RubySimpleSearch::Errors::INVALID_CONDITION, error.message
  end

  def test_returns_an_exception_if_condition_is_not_an_array_type
    error = assert_raises(RuntimeError) do
      User.simple_search('usa') do
        'Wrong return'
      end
    end

    assert_equal RubySimpleSearch::Errors::INVALID_TYPE, error.message
  end

  def test_searches_the_users_with_age_is_26
    searched_users = User.simple_search('26', pattern: :containing, attributes: :age)
    assert_equal [26], searched_users.pluck(:age)
  end

  def test_it_searches_the_users_with_username_and_it_ends_with_khan_word
    searched_users = User.simple_search('khan', pattern: :ending, attributes: [:username])
    assert_equal ['kingkhan'], searched_users.pluck(:username)
  end

  def test_it_searches_the_users_with_email_containing_example_word
    searched_users = User.simple_search('example', pattern: :containing, attributes: [:email])
    assert_equal ['alice@example.com', 'bob@example.com'], searched_users.pluck(:email)
  end

  def test_searches_user_with_name_or_address_containing_a_word
    searched_users = User.simple_search('a', pattern: :containing, attributes: [:name, :address])
    assert_equal ['alice', 'bob'], searched_users.pluck(:name)
    assert_equal ['usa', 'india'], searched_users.pluck(:address)
  end
end

module JoinTest
  def test_simple_search_using_join
    searched_users = User.joins(:posts).simple_search('alice') do |_|
      ['AND posts.name = ? ', 'Ruby is simple' ]
    end

    assert_equal ['alice'], searched_users.pluck(:name)
  end
end

module ExcpetionsTest
  def test_returns_an_exception_if_simple_search_attributes_method_is_not_called_while_loading_the_model
    User2.simple_search_attributes

    error = assert_raises(RuntimeError) { User2.simple_search('usa') }

    assert_equal RubySimpleSearch::Errors::ATTRIBUTES_MISSING, error.message
  end

  def test_returns_an_exception_if_search_term_argument_is_not_string_type
    User2.simple_search_attributes :name, :contact

    error = assert_raises(ArgumentError) { User2.simple_search(1) }

    assert_equal RubySimpleSearch::Errors::SEARCH_ARG_TYPE, error.message
  end

  def test_returns_an_exception_if_simple_search_attributes_method_has_wrong_attribute_type
    error = assert_raises(ArgumentError) { User2.simple_search_attributes :name, '24' }

    assert_equal RubySimpleSearch::Errors::WRONG_ATTRIBUTES, error.message
  end

  def test_it_sets_attributes_internally_if_simple_search_attributes_method_is_called_on_the_model
    User2.simple_search_attributes :name, :contact

    assert_equal [:name, :contact], User2.instance_variable_get('@simple_search_attributes')
  end
end
