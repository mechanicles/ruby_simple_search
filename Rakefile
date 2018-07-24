require 'bundler/gem_tasks'
require 'rake/testtask'

task :test do
  sh "ruby test/sqlite_test.rb"
  sh "ruby test/mysql_test.rb"
  sh "ruby test/postgresql_test.rb"
end
