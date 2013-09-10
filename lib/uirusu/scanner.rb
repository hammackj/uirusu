# Copyright (c) 2012-2013 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# Neither the name of the project's author nor the names of its contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'pathname'
require 'digest/md5'

module Uirusu

	module Scanner
		@hash_list = Array.new

		# Recursively lists all files in a directory
		# calling process_file on each file
		#
		def Scanner.recurse (file_name)
			Dir.new("#{file_name}").each do |file|
				next if file.match(/^\.+/)
				path = "#{file_name}/#{file}"

				if  FileTest.directory?("#{path}")
					recurse("#{path}")
				else
					process_file(path)
				end
			end
		end

		# Processes a file, hashing it with MD5
		#
		def Scanner.process_file (file)
			begin
				digest = Digest::MD5.hexdigest(File.read(file))
				@hash_list << digest

			rescue Exception => e
				puts "[!] Cannot read #{file}"
			end
		end

		# Enumerates a directory recursively then returns the hash list
		#
		# @return [Array] Hash List
		def Scanner.scan directory
			recurse(directory)

			return @hash_list
		end
	end
end
