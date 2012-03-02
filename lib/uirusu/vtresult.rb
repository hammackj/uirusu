module Uirusu
	#
	#
	class VTResult
		def initialize hash, result
			if result == nil
				return
			end

			@results = Array.new

			if result["response_code"] == 0
				res = Hash.new
				res['hash'] = hash
				res['scanner'] = '-'
				res['md5'] = '-'
				res['sha1'] = '-'
				res['sha256'] = '-'
				res['detected'] = '-'
				res['version'] = '-'
				res['result']  = '-'
				res['update'] = '-'
				res['permalink'] = '-'
				res['result'] = result["verbose_msg"]

				@results.push res
			elsif result["response_code"] == 0
				puts "[!] Invalid API KEY! Please correct this! Check ~/.uirusu"
				exit
			else
				permalink = result["permalink"]
				date = result["scan_date"]
				md5 = result["md5"]
				sha1 = result["sha1"]
				sha256 = result["sha256"]
				
				result["scans"].each do |scanner, value|
					if value != ''
						res = Hash.new
						res['hash'] = hash
						res['md5'] = md5
						res['sha1'] = sha1
						res['sha256'] = sha256
						res['scanner'] = scanner
						res['detected'] = value["detected"]
						res['version'] = value["version"]

						if value["result"] == nil
							res['result'] = "Nothing detected"
						else
							res['result']  = value["result"]
						end
						
						res['update'] = value['update']
						res['permalink'] = permalink unless permalink == nil

						@results.push res
					end
				end
			end
			
			#if we didn't have any results let create a fake not found
			if @results.size == 0
				res = Hash.new
				res['hash'] = hash
				res['scanner'] = '-'
				res['md5'] = '-'
				res['sha1'] = '-'
				res['sha256'] = '-'
				res['permalink'] = '-'
				res['detected'] = '-'
				res['version'] = '-'
				res['result']  = '-'
				res['update'] = '-'
				res['result'] = result["verbose_msg"]
				@results.push res				
			end
		end

		#
		#
		def to_stdout
			result_string = String.new
			@results.each do |result|				
				result_string << "#{result['hash']}: Scanner: #{result['scanner']} Result: #{result['result']}\n"
			end
			
			print result_string
		end

		#
		#
		def to_yaml
			result_string = String.new
			@results.each do |result|
				result_string << "vtresult:\n"
				result_string << "  hash: #{result['hash']}\n"
				result_string << "  md5: #{result['md5']}\n"
				result_string << "  sha1: #{result['sha1']}\n"
				result_string << "  sha256: #{result['sha256']}\n"
				result_string << "  scanner: #{result['scanner']}\n"
				result_string << "  detected: #{result['detected']}\n"
				result_string << "  date: #{result['date']}\n"
				result_string << "  permalink: #{result['permalink']}\n" unless result['permalink'] == nil
				result_string << "  result: #{result['result']}\n\n"
			end
			
			print result_string
		end

		#
		#
		def to_xml
			result_string = String.new
			@results.each do |result|
				result_string << "\t<vtresult>\n"
				result_string << "\t\t<hash>#{result['hash']}</hash>\n"
				result_string << "\t\t<md5>#{result['md5']}</md5>\n"
				result_string << "\t\t<sha1>#{result['sha1']}</sha1>\n"
				result_string << "\t\t<sha256>#{result['sha256']}</sha256>\n"
				result_string << "\t\t<scanner>#{result['scanner']}</scanner>\n"
				result_string << "\t\t<detected>#{result['detected']}</detected>\n"
				result_string << "\t\t<date>#{result['date']}</date>\n"
				result_string << "\t\t<permalink>#{result['permalink']}</permalink>\n" unless result['permalink'] == nil
				result_string << "\t\t<result>#{result['result']}</result>\n"
				result_string << "\t</vtresult>\n"
			end
			
			print result_string
		end
	end
end
