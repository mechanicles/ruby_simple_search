# frozen_string_literal: true

module RubySimpleSearch
  module Errors
    ATTRIBUTES_MISSING = "Simple search attributes are missing"
    INVALID_CONDITION  = "Extended query's array conditions are wrong"
    INVALID_TYPE       = "Extended query is not an array type"
    INVALID_PATTERN    = "Looks like given pattern is wrong, valid pattern list is '#{LIKE_PATTERNS.keys}'"
    SEARCH_ARG_TYPE    = "`search_term` argument is not a string"
    WRONG_ATTRIBUTES   = "`simple_search_arguments` method's arguments should be in symbol format"
  end
end
