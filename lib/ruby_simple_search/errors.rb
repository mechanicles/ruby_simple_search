module RubySimpleSearch

  module Errors

    ATTRIBUTES_MISSING = "Simple search attributes are missing"
    INVALID_TYPE       = "Extended query is not an array type"
    INVALID_CONDITION  = "Extended query's array conditions are wrong"
    INVALID_PATTERN    = "Looks like given pattern is wrong, valid pattern list is '#{RubySimpleSearch::LIKE_PATTERNS.keys}'"
    WRONG_ATTRIBUTES   = "`simple_search_arguments` method's arguments should be in symbol format"

  end

end
