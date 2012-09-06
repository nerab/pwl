# encoding: utf-8

#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test' << 'test/unit'
  #test.pattern = 'test/unit/test_*.rb'
  test.test_files = FileList['test/**/test_*.rb'].exclude("test/acceptance/test_dialogs.rb")
end

task :default => :test
