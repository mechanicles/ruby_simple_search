require "ruby_simple_search/errors"

module RubySimpleSearch
  module Errors
    ATTRIBUTES_MISSING     = "Simple search attributes are missing"
    INVALID_TYPE           = "Extended query is not an array type"
    INVALID_CONDITION      = "Extended query's array conditions are wrong"
    INVALID_PATTERN        = "Pattern is wrong. it should be in the list #{RubySimpleSearch::LIKE_PATTERNS.keys}"
    WROG_ATTRIBUTES        = "simple_search_arguments method's arguments should be in symbol format"
  end
end
