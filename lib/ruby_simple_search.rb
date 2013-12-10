require "ruby_simple_search/version"
require "ruby_simple_search/like_pattern"
require "ruby_simple_search/errors"
require 'active_support/concern'

module RubySimpleSearch
  extend ActiveSupport::Concern

  included do
    class_eval do
      def self.simple_search_attributes(*args)
        @simple_search_attributes = []
        # default pattern is '%q%'
        @simple_search_pattern = RubySimpleSearch::LIKE_PATTERNS[:containing]
        args.each do |arg|
          if !arg.is_a?(Hash)
            @simple_search_attributes << arg
          else
            pattern = RubySimpleSearch::LIKE_PATTERNS[arg[:pattern].to_sym] rescue nil
            raise RubySimpleSearch::Error::INVALID_PATTERN if pattern.nil?
            @simple_search_pattern = pattern
          end
        end
      end
    end
  end

  module ClassMethods
    def simple_search(search_term, &block)
      raise RubySimpleSearch::Error::ATTRIBUTES_MISSING if @simple_search_attributes.blank?
      raise ArgumentError, "Argument is not string" unless search_term.is_a? String

      sql_query = nil
      extended_query = nil
      sql_query_condition = ""
      sql_query_values = []

      patterned_text = "#{@simple_search_pattern.gsub('q', search_term.try(:downcase))}"

      @simple_search_attributes.each do |attr|
        sql_query_condition = if sql_query_condition.blank?
                                "(LOWER(#{attr.to_s}) LIKE ?"
                              else
                                "#{sql_query_condition} OR LOWER(#{attr.to_s}) LIKE ?"
                              end
        sql_query_values << patterned_text
      end
      sql_query_condition << ")"

      extended_query = block.call(search_term) if block.is_a? Proc

      if !extended_query.nil?
        sql_query_values, sql_query_condition = extend_simple_search(extended_query,
                                                                     sql_query_condition,
                                                                     sql_query_values)
      end
      sql_query = [sql_query_condition, sql_query_values]

      where(sql_query.try(:flatten))
    end

    def extend_simple_search(extended_query, sql_query_condition, sql_query_values)
      raise RubySimpleSearch::Error::INVALID_TYPE unless extended_query.is_a?(Array)
      extended_query_condition = extended_query[0]
      extended_query_values = extended_query - [extended_query[0]]

      if extended_query_condition.count('?') != (extended_query_values.size)
        raise RubySimpleSearch::Error::INVALID_PARAMETERS
      end

      sql_query_condition = [sql_query_condition, extended_query_condition].join(' ')
      sql_query_values = sql_query_values + extended_query_values

      [sql_query_values, sql_query_condition]
    end
  end
end
