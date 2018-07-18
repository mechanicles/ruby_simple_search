module RubySimpleSearch
  module Errors
    ATTRIBUTES_MISSING = 'Simple search attributes are missing'.freeze
    INVALID_TYPE       = 'Extended query is not an array type'.freeze
    INVALID_CONDITION  = "Extended query's array conditions are wrong".freeze
    INVALID_PATTERN    = "Looks like given pattern is wrong, valid pattern list is '#{RubySimpleSearch::LIKE_PATTERNS.keys}'".freeze
    WRONG_ATTRIBUTES   = "`simple_search_arguments` method's arguments should be in symbol format".freeze
  end
end
