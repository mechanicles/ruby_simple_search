require "ruby_simple_search/errors"

module RubySimpleSearch
  module Error
    ATTRIBUTES_MISSING     = "Simple search attributes are missing"
    INVALID_TYPE           = "Extended query is not an array type"
    INVALID_CONDITION      = "Extended query's array conditions are wrong"
    INVALID_PATTERN        = "Pattern is wrong. it should be in the list #{RubySimpleSearch::LIKE_PATTERNS.keys}"
    INVALID_CASE_SENSITIVE = "Case sensitive value is invalid"
  end
end
