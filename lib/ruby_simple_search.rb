require "ruby_simple_search/version"
require "ruby_simple_search/like_pattern"
require "ruby_simple_search/errors"
require "active_support/concern"

module RubySimpleSearch

  extend ActiveSupport::Concern

  included do
    class_eval do
      def self.simple_search_attributes(*args)
        @simple_search_attributes = []
        args.each do |arg|
          raise ArgumentError, RubySimpleSearch::Errors::WRONG_ATTRIBUTES unless arg.is_a? Symbol
          @simple_search_attributes << arg
        end
      end
    end
  end

  module ClassMethods

    def simple_search(search_term, options={}, &block)

      raise RubySimpleSearch::Errors::ATTRIBUTES_MISSING if @simple_search_attributes.blank?
      raise ArgumentError, "Argument is not string" unless search_term.is_a? String

      set_pattern(options[:pattern])

      extended_query      = nil
      sql_query_condition = ""
      sql_query_values    = []

      patterned_text = "#{@simple_search_pattern.gsub('q', search_term.try(:downcase))}"


      if options[:attributes].nil?
        sql_query_values, sql_query_condition = search_attributes(@simple_search_attributes, patterned_text, search_term)
      else
        attr = *options[:attributes]
        sql_query_values, sql_query_condition = search_attributes(attr, patterned_text, search_term)
      end

      if block.is_a? Proc
        sql_query_condition = "(#{sql_query_condition})"
        extended_query = block.call(search_term)
      end

      if !extended_query.nil?
        sql_query_values, sql_query_condition = extend_simple_search(extended_query,
                                                                     sql_query_condition,
                                                                     sql_query_values)
      end

      sql_query = [sql_query_condition, sql_query_values]
      where(sql_query.flatten)

    end

    private

    def set_pattern(pattern)
      if pattern.nil?
        # default pattern is '%q%'
        @simple_search_pattern = RubySimpleSearch::LIKE_PATTERNS[:containing]
      else
        pattern = RubySimpleSearch::LIKE_PATTERNS[pattern.to_sym]

        raise RubySimpleSearch::Errors::INVALID_PATTERN if pattern.nil?

        @simple_search_pattern = pattern
      end
    end

    def extend_simple_search(extended_query, sql_query_condition, sql_query_values)
      raise RubySimpleSearch::Errors::INVALID_TYPE unless extended_query.is_a?(Array)

      extended_query_condition = extended_query[0]
      extended_query_values    = extended_query - [extended_query[0]]

      if extended_query_condition.count('?') != (extended_query_values.size)
        raise RubySimpleSearch::Errors::INVALID_CONDITION
      end

      sql_query_condition = [sql_query_condition, extended_query_condition].join(' ')
      sql_query_values = sql_query_values + extended_query_values

      [sql_query_values, sql_query_condition]
    end

    def set_sql_query_condition(attr, sql_query_condition, patterned_text, search_term)
      if [:string, :text].include?(self.columns_hash[attr.to_s].type)
        condition = if sql_query_condition.blank?
                      "LOWER(#{self.table_name}.#{attr.to_s}) LIKE ?"
                    else
                      " OR LOWER(#{self.table_name}.#{attr.to_s}) LIKE ?"
                    end
        [condition, patterned_text]
      else
        condition = if sql_query_condition.blank?
                      "#{self.table_name}.#{attr.to_s} = ?"
                    else
                      " OR #{self.table_name}.#{attr.to_s} = ?"
                    end
        [condition, search_term]
      end
    end

    def search_attributes(attributes, patterned_text, search_term)
      sql_query_condition = ""
      sql_query_values = []

      attributes.each do |attr|
        condition, needed_search_term = set_sql_query_condition(attr, sql_query_condition, patterned_text, search_term)

        sql_query_condition << condition
        sql_query_values << needed_search_term
      end

      [sql_query_values, sql_query_condition]
    end

  end

end
