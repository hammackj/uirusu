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


base = __FILE__
$:.unshift(File.join(File.dirname(base), 'lib'))

require 'uirusu/version'

Gem::Specification.new do |s|
	s.name = Uirusu::APP_NAME
	s.version = Uirusu::VERSION
	s.homepage = Uirusu::HOME_PAGE
	s.author = Uirusu::AUTHOR
	s.email = Uirusu::EMAIL

	s.summary = Uirusu::APP_NAME
	s.description = "uirusu is tool and REST library for interacting with Virustotal.org"
	s.license = "MIT"

	s.files = Dir['[A-Z]*'] + Dir['lib/**/*'] + ['uirusu.gemspec']
	s.default_executable = Uirusu::APP_NAME
	s.executables = ["#{Uirusu::APP_NAME}"]
	s.require_paths	= ["lib"]

	s.has_rdoc = 'yard'
	s.extra_rdoc_files = ["README.markdown", "LICENSE", "docs/NEWS.markdown", "docs/TODO.markdown"]

	s.add_runtime_dependency 'rake', '~> 12.0', '>= 12.0.0'
	s.add_runtime_dependency 'json', '~> 2.0', '>= 2.0.3'
	s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'

	s.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7.6'
	s.add_development_dependency 'minitest', '~> 5.0', '>= 5.10.1'
	s.add_development_dependency 'test-unit', '~> 3.2', ">= 3.2"
end
