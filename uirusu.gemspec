base = __FILE__
$:.unshift(File.join(File.dirname(base), 'lib'))

require 'uirusu'

Gem::Specification.new do |s|
	s.name 						= Uirusu::APP_NAME
	s.version 					= Uirusu::VERSION
	s.homepage 					= "http://github.com/arxopia/uirusu/"
	s.summary 					= Uirusu::APP_NAME
	s.description 				= "uirusu is library for interacting with Virustotal.org"
	s.license					= "BSD"

	s.author 					= "Jacob Hammack"
	s.email 					= "uirusu@arxopia.com"

	s.files 					= Dir['[A-Z]*'] + Dir['lib/**/*'] + ['uirusu.gemspec']
	s.default_executable 		= 'uirusu'
	s.executables 				= ['uirusu']
	s.require_paths 			= ["lib"]

	s.required_ruby_version 	= '>= 1.9.2'
	s.required_rubygems_version = ">= 1.8.16"

	s.has_rdoc 					= 'yard'
	s.extra_rdoc_files 			= ["README.markdown", "LICENSE", "NEWS.markdown", "TODO.markdown"]

	s.add_dependency('json', '>= 1.5.1')
	s.add_dependency('rest-client', '>= 1.6.1')

end
