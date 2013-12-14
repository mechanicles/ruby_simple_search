# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_simple_search/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby_simple_search"
  gem.version       = RubySimpleSearch::VERSION
  gem.authors       = ["Santosh Wadghule"]
  gem.email         = ["santosh.wadghule@gmail.com"]
  gem.description   = %q{It will search on the attributes that you provided to simple_search_attributes method}
  gem.summary       = %q{Ruby simple search for ActiveRecord}
  gem.homepage      = "https://github.com/mechanicles/ruby_simple_search"

  gem.add_dependency "activesupport", ">= 3.0.0"
  gem.add_dependency "activerecord",  ">= 3.0.0"
  gem.add_dependency "sqlite3"
  gem.add_development_dependency "rspec"
  gem.required_ruby_version = ">= 1.9.2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
