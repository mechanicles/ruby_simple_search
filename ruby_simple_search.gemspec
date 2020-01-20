# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_simple_search/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_simple_search"
  spec.version       = RubySimpleSearch::VERSION
  spec.summary       = "The simplest way to search the data"
  spec.homepage      = "https://github.com/mechanicles/ruby_simple_search"
  spec.license       = "MIT"

  spec.authors       = "Santosh Wadghule"
  spec.email         = "santosh.wadghule@gmail.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_paths = "lib"

  spec.required_ruby_version = ">= 2.2"

  spec.add_dependency "activerecord", ">= 5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "activerecord"

  spec.add_development_dependency "pg", "< 1"
  spec.add_development_dependency "mysql2", "< 0.5"
  spec.add_development_dependency "sqlite3"
end
