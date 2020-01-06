# frozen_string_literal: true

module RubySimpleSearch
  LIKE_PATTERNS = {
    plain: "q",
    beginning: "q%",
    ending: "%q",
    containing: "%q%"
  }
end
