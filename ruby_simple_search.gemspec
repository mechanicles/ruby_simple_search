# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_simple_search/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_simple_search"
  spec.version       = RubySimpleSearch::VERSION
  spec.authors       = ["Santosh Wadghule"]
  spec.email         = ["santosh.wadghule@gmail.com"]
  spec.description   = %q{Searches through the attributes (table's columns)}
  spec.summary       = %q{Ruby simple search for ActiveRecord}
  spec.homepage      = "https://github.com/mechanicles/ruby_simple_search"

  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_dependency "activerecord",  ">= 3.0.0"
  spec.add_dependency "sqlite3"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.required_ruby_version = ">= 1.9.2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
