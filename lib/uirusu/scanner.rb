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

require 'pathname'
require 'digest/md5'

module Uirusu

	module Scanner
		@hash_list = Array.new

		# Recursively lists all files in a directory
		# calling process_file on each file
		#
		def Scanner.recurse file_name
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
		def Scanner.process_file file
			begin
				digest = Digest::MD5.hexdigest(File.read(file))
				@hash_list << digest

			rescue Exception
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
