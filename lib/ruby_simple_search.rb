# RubySimpleSearch allows to search on the table fields. 
# e.g. string and text fields.
#
# Sometimes we want to do search on the post's title and content
# or user's email, username and description or on other models but in same way.
# For those searches we use MySql's or PostgreSQL's LIKE operator to get the
# results. While doing same thing on the different models you actually add lots of
# duplications in your code.
#
# To avoid duplicating the same code, use RubySimpleSearch :)
#
# Define attributes that you want to search through RubySimpleSearch
#
#   class Post < ActiveActiveRecord::Base
#     include RubySimpleSearch
#
#     simple_search_attributes :title, :description
#   end
#
#   class User < ActiveActiveRecord::Base
#     include RubySimpleSearch
#
#     simple_search_attributes :email, :username, :address
#   end
#
#  Post.simple_search('tutorial')
#  # => posts which have tutorial text in title or in description fields
#
#  User.simple_search('Mechanicles')
#  # => users which have mechanicles text in the email, username and in address
#
#  Model.simple_search('string') will return ActiveRecord::Relation object


require "ruby_simple_search/version"
require 'active_support/concern'

module RubySimpleSearch
  extend ActiveSupport::Concern

  included do
    class_eval do
      def self.simple_search_attributes(*args)
        @simple_search_attributes = []
        args.each do |arg|
          @simple_search_attributes << arg
        end
      end
    end
  end

  module ClassMethods
    def simple_search(q)
      raise ArgumentError, "Argument is not string" unless q.is_a? String

      query = ""
      patterned_text = "%#{q.downcase}%"

      @simple_search_attributes.each do |attr|
        query += if query == ""
                   "LOWER(#{attr.to_s}) LIKE ?" 
                 else
                   " OR LOWER(#{attr.to_s}) LIKE ?"
                 end

      end

      where([query] + Array.new(@simple_search_attributes.size, patterned_text))
    end
  end
end
