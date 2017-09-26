module RubySimpleSearch

  LIKE_PATTERNS = {
    plain: 'q',
    underscore: '_q_',
    beginning: 'q%',
    ending: '%q',
    containing: '%q%'
  }.freeze

end
