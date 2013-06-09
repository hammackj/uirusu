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
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Uirusu

	# A wrapper class to hold all of the data for a single Virus total result
	class VTResult
		RESULT_FIELDS = Uirusu::RESULT_FIELDS

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
					res['result'] = result['verbose_msg']
					@results.push res

					#res['hash'] = hash
					#res['scanner'] = '-'
					#res['md5'] = '-'
					#res['sha1'] = '-'
					#res['sha256'] = '-'
					#res['detected'] = '-'
					#res['version'] = '-'
					#res['result']  = '-'
					#res['update'] = '-'
					#res['permalink'] = '-'
					#res['result'] = result['verbose_msg']
	
					#@results.push res
				elsif result['response_code'] == 0
					abort "[!] Invalid API KEY! Please correct this! Check ~/.uirusu"
				else
					permalink = result['permalink']
					date = result['scan_date']
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
				res['result'] = result['verbose_msg']
				@results.push res
				#res['hash'] = hash
				#res['scanner'] = '-'
				#res['md5'] = '-'
				#res['sha1'] = '-'
				#res['sha256'] = '-'
				#res['permalink'] = '-'
				#res['detected'] = '-'
				#res['version'] = '-'
				#res['result']  = '-'
				#res['update'] = '-'
				#res['result'] = result['verbose_msg']
				#@results.push res
			end
		end

		#
		#
		def to_stdout
			result_string = String.new
			hashes = Array.new
			#@results.each do |result|
			#@results.each do |result|
			@results.sort_by {|k| k[:scanner] }.each do |result|
				#result_string << "#{result['hash']}: Scanner: #{result['scanner']} Result: #{result['result']}\n"
				#result_string << "#{result[:hash]}: Scanner: #{result[:scanner]} Result: #{result[:result]}\n"
				unless hashes.include? result[:hash].downcase
					result_string << "#{result[:hash]}:\n"
					hashes << result[:hash].downcase
				end
				result_string << "#{result[:scanner]}: ".rjust(25) + "#{result[:result]}\n"
			end if @results != nil

			print result_string
		end

		#
		#
		def to_json
			require 'pp'
			#json = JSON::pretty_generate(@results.map{|entry| { :vtresult => entry })
			#pp JSON::parse(json)
			JSON::pretty_generate(@results.map{|entry| { :vtresult => entry } })
		end

		#
		#
		def to_yaml
			@results.map{|entry| { :vtresult => entry } }.to_yaml
			#require 'pp'
			#yaml = @results.map{|entry| :vtresult => entry }.to_yaml
			#yaml = @results.map{|entry| { 'vtresult' => entry }.to_yaml }
			#puts @results.map{|entry| { 'vtresult' => entry }.to_yaml }
			#yaml = @results.map{|entry| { :vtresult => entry } }.to_yaml
			#pp YAML::load(yaml)
			#puts yaml
			#puts "-"*70
			#return
			#result_string = String.new
			#@results.each do |result|
			#	result_string << "vtresult:\n"
			#	result_string << "  hash: #{result['hash']}\n"
			#	result_string << "  md5: #{result['md5']}\n"
			#	result_string << "  sha1: #{result['sha1']}\n"
			#	result_string << "  sha256: #{result['sha256']}\n"
			#	result_string << "  scanner: #{result['scanner']}\n"
			#	result_string << "  detected: #{result['detected']}\n"
			#	result_string << "  date: #{result['date']}\n"
			#	result_string << "  permalink: #{result['permalink']}\n" unless result['permalink'] == nil
			#	result_string << "  result: #{result['result']}\n\n"
			#end if @results != nil
			#print result_string
		end

		#
		#
		def to_xml
			result_string = String.new

			@results.each do |result|
				result_string << "\t<vtresult>\n"
				RESULT_FIELDS.each{|field|
					result_string << "\t\t<#{field.to_s}>#{result[field]}</#{field.to_s}>\n" unless field == :permalink and result['permalink'].nil?
				}
				result_string << "\t</vtresult>\n"
				#result_string << "\t\t<hash>#{result[:hash]}</hash>\n"
				#result_string << "\t\t<md5>#{result[:md5]}</md5>\n"
				#result_string << "\t\t<sha1>#{result[:sha1]}</sha1>\n"
				#result_string << "\t\t<sha256>#{result[:sha256]}</sha256>\n"
				#result_string << "\t\t<scanner>#{result[:scanner]}</scanner>\n"
				#result_string << "\t\t<detected>#{result[:detected]}</detected>\n"
				#result_string << "\t\t<date>#{result[:date]}</date>\n"
				#result_string << "\t\t<permalink>#{result[:permalink]}</permalink>\n" unless result['permalink'] == nil
				#result_string << "\t\t<result>#{result[:result]}</result>\n"
			end if @results != nil

			print result_string
		end
	end
end
