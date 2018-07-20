lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_simple_search/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_simple_search'
  spec.version       = RubySimpleSearch::VERSION
  spec.authors       = ['Santosh Wadghule']
  spec.email         = ['santosh.wadghule@gmail.com']
  spec.description   = 'The simplest way to search the data'
  spec.summary       = 'The simplest way to search the data'
  spec.homepage      = 'https://github.com/mechanicles/ruby_simple_search'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 3'

  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'

  if RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'activerecord-jdbcmysql-adapter'
    spec.add_development_dependency 'activerecord-jdbcpostgresql-adapter'
    spec.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
  else
    spec.add_development_dependency 'mysql2', '~> 0.3.20'
    spec.add_development_dependency 'pg'
    spec.add_development_dependency 'sqlite3'
  end
end
