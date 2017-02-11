# Copyright (c) 2010-2017 Jacob Hammack.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "uirusu"
require 'rake'
require 'rake/testtask'

task :build do
	system "gem build #{Uirusu::APP_NAME}.gemspec"
end

task :tag_and_bag do
	system "git tag -a v#{Uirusu::VERSION} -m 'version #{Uirusu::VERSION}'"
	system "git push --tags"
	system "git checkout master"
	system "git merge dev"
	system "git push"
end

task :push => [:build] do
	system "gem push #{Uirusu::APP_NAME}-#{Uirusu::VERSION}.gem"
end

task :release => [:tag_and_bag, :push] do
	puts "Just released #{Uirusu::APP_NAME} v#{Uirusu::VERSION}. #{Uirusu::APP_NAME} is rubygem for using the Virustotal web service! More information at #{Uirusu::HOME_PAGE}"
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
