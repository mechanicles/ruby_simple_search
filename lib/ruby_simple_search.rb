# frozen_string_literal: true

require "ruby_simple_search/version"
require "ruby_simple_search/like_patterns"
require "ruby_simple_search/errors"
require "active_support/concern"

module RubySimpleSearch
  extend ActiveSupport::Concern

  included do
    instance_eval do
      def simple_search_attributes(*args)
        @simple_search_attributes = []
        args.each do |arg|
          raise ArgumentError, Errors::WRONG_ATTRIBUTES unless arg.is_a? Symbol

          @simple_search_attributes << arg
        end
      end
    end
  end

  module ClassMethods
    def simple_search(search_term, options = {}, &block)
      raise Errors::ATTRIBUTES_MISSING if @simple_search_attributes.blank?
      raise ArgumentError, Errors::SEARCH_ARG_TYPE unless search_term.is_a? String

      @simple_search_term             = search_term
      @simple_search_pattern          = get_pattern(options[:pattern])
      @simple_search_patterned_text   = @simple_search_pattern.gsub("q", @simple_search_term.try(:downcase))
      @simple_search_query_conditions = []
      @simple_search_query_values     = []

      build_query_conditions_and_values(options)
      extend_query(block) if block.is_a? Proc

      sql_query = [@simple_search_query_conditions.join, @simple_search_query_values]
      where(sql_query.flatten)
    end

    private
      def get_pattern(pattern)
        if pattern.nil?
          # default pattern is '%q%'
          LIKE_PATTERNS[:containing]
        else
          pattern = LIKE_PATTERNS[pattern.to_sym]
          raise Errors::INVALID_PATTERN if pattern.nil?

          pattern
        end
      end

      def build_query_conditions_and_values(options)
        attributes = if options[:attributes].nil?
          @simple_search_attributes
        else
          _attr = *options[:attributes]
        end

        attributes.each do |attribute|
          condition, value = build_query_condition_and_value(attribute)

          @simple_search_query_conditions << condition
          @simple_search_query_values << value
        end
      end

      def build_query_condition_and_value(attribute)
        condition = if %i[string text].include?(columns_hash[attribute.to_s].type)
          build_query_for_string_and_text_types(attribute)
        else
          build_query_non_string_and_text_types(attribute)
        end

        [condition, @simple_search_patterned_text]
      end

      def build_query_for_string_and_text_types(attribute)
        if @simple_search_query_conditions.blank?
          "LOWER(#{table_name}.#{attribute}) LIKE ?"
        else
          " OR LOWER(#{table_name}.#{attribute}) LIKE ?"
        end
      end

      def build_query_non_string_and_text_types(attribute)
        if @simple_search_query_conditions.blank?
          "CAST(#{table_name}.#{attribute} AS CHAR(255)) LIKE ?"
        else
          " OR CAST(#{table_name}.#{attribute} AS CHAR(255)) LIKE ?"
        end
      end

      def extend_query(block)
        @simple_search_query_conditions = ["(#{@simple_search_query_conditions.join})"]
        extended_query = block.call @simple_search_term
        extend_simple_search(extended_query) if extended_query
      end

      def extend_simple_search(extended_query)
        raise Errors::INVALID_TYPE unless extended_query.is_a?(Array)

        extended_query_condition = extended_query[0]
        extended_query_values    = extended_query - [extended_query[0]]

        if extended_query_condition.count("?") != extended_query_values.size
          raise Errors::INVALID_CONDITION
        end

        @simple_search_query_conditions << " #{extended_query_condition}"
        @simple_search_query_values += extended_query_values
      end
  end
end
