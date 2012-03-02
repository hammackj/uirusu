$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require "uirusu"
require 'rake'
require 'rake/testtask'

task :build do
  system "gem build #{Uirusu::APP_NAME}.gemspec"
end

task :release => :build do
  system "gem push #{Uirusu::APP_NAME}-#{Uirusu::VERSION}.gem"
	puts "Just released #{Uirusu::APP_NAME} v#{Uirusu::VERSION}. #{Uirusu::APP_NAME} is always available in RubyGems! More information at http://hammackj.com/projects/uirusu/"
end

task :clean do
	system "rm *.gem"
	system "rm -rf coverage"
end

task :default => [:test]

Rake::TestTask.new("test") do |t|
	t.libs << "test"
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
end
