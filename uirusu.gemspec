# Copyright (c) 2012-2016 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

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

	s.add_runtime_dependency 'rake', '~> 11.2', '>= 11.2.2'
	s.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.3'
	s.add_runtime_dependency 'rest-client', '~> 1.8', '>= 1.8.0'

	s.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7.6'
	s.add_development_dependency 'minitest', '~> 5.0', '>= 5.9'
	s.add_development_dependency 'test-unit', '~> 3.2', ">= 3.2"
end
