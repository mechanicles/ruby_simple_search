module RubySimpleSearch
  LIKE_PATTERNS = {
    plain: 'q',
    beginning: 'q%',
    ending: '%q',
    containing: '%q%'
  }.freeze
end
