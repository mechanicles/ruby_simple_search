require 'active_record'
require_relative "../../lib/ruby_simple_search.rb"

class User2 < ActiveRecord::Base
  include RubySimpleSearch
end
