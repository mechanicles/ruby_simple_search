require 'active_record'
require_relative "../../lib/ruby_simple_search.rb"

class User < ActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :name, :email, :contact, :address
end
