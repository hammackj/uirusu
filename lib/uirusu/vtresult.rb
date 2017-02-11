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

module Uirusu

	# A wrapper class to hold all of the data for a single Virus total result
	class VTResult
		RESULT_FIELDS = Uirusu::RESULT_FIELDS

		attr_accessor :results

		# Builds a VTResult object based on the hash and results passed to it
		#
		# @param hash, Cryptographic hash that was searched
		# @param results, Results of the search on Virustotal.com
		#
		def initialize hash, results
			if results == nil or results.empty?
				return

			# Take into consideration being passed an array of results.
			# For instance, rescan_file will return an array if more than
			# one sample is given.  This ensures single results work.
			elsif not results.is_a? Array
				results = [ [ hash, results ] ]
			end

			@results = Array.new

			# Results will be an array of: [ [resource, result hash ] ]
			results.each do |entry|
				hash   = entry.first # Grab the resource (checksum hash)
				result = entry.last  # Grab the query report

				if result['response_code'] == 0
					res = Hash.new
					RESULT_FIELDS.each{|field| res[field] = '-' }
					res[:hash] = hash
					res['result'] = result['verbose_msg']
					@results.push res

				elsif result['response_code'] == 0
					abort "[!] Invalid API KEY! Please correct this! Check ~/.uirusu"
				else
					permalink = result['permalink']
					scan_date = result['scan_date']
					md5 = result['md5']
					sha1 = result['sha1']
					sha256 = result['sha256']

					result['scans'].each do |scanner, value|
						if value != ''
							res = Hash.new
							res[:hash] = hash
							res[:md5] = md5
							res[:sha1] = sha1
							res[:sha256] = sha256
							res[:scanner] = scanner
							res[:detected] = value['detected']
							res[:version] = value['version']

							if value['result'] == nil
								res[:result] = "Nothing detected"
							else
								res[:result] = value['result']
							end

							res[:scan_date] = scan_date
							res[:update] = value['update']
							res[:permalink] = permalink unless permalink == nil

							@results.push res
						end
					end
				end
			end

			#if we didn't have any results lets create a fake not found
			if @results.size == 0
				res = Hash.new
				RESULT_FIELDS.each{|field| res[field] = '-' }
				res[:hash] = hash
				res['result'] = result['verbose_msg']
				@results.push res
			end
		end

		# Outputs the result to STDOUT
		#
		# @return [String] Pretty text printable representation of the result
		def to_stdout
			result_string = String.new
			hashes = Array.new

			@results.sort_by {|k| k[:scanner] }.each do |result|
				unless hashes.include? result[:hash].downcase
					result_string << "#{result[:hash]}:\n"
					hashes << result[:hash].downcase
				end
				result_string << "#{result[:scanner]}: ".rjust(25) + "#{result[:result]}\n"
			end if @results != nil

			result_string
		end

		# Outputs the result to JSON
		#
		# @return [String] JSON representation of the result
		def to_json(options={})
			JSON::pretty_generate(@results.map{|entry| { :vtresult => entry } })
		end

		# Outputs the result to YAML
		#
		# @return [String] YAML representation of the result
		def to_yaml
			@results.map{|entry| { :vtresult => entry } }.to_yaml
		end

		# Outputs the result to XML
		#
		# @return [String] XML representation of the result
		def to_xml
			result_string = String.new
			result_string << "<results>\n"
			@results.each do |result|
				result_string << "\t<vtresult>\n"
				RESULT_FIELDS.each{|field|
					result_string << "\t\t<#{field.to_s}>#{result[field]}</#{field.to_s}>\n" unless field == :permalink and result['permalink'].nil?
				}
				result_string << "\t</vtresult>\n"
			end if @results != nil
			result_string << "</results>\n"

			result_string
		end
	end
end
