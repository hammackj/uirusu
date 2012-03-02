module Uirusu
	# Module for Accessing the File scan and report functionalities of the
	# Virustotal.com public API
	module VTFile
		SCAN_URL = "http://www.virustotal.com/vtapi/v2/file/scan"
		REPORT_URL = "https://www.virustotal.com/vtapi/v2/file/report"
		
		# Queries a report from Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource MD5/sha1/sha256/scan_id to search for
		#
		# @return [JSON] Parsed response
		def VTFile.query_report(api_key, resource)
			if api_key == nil
				raise "Invalid API Key"
			end
			
			if resource == nil
				raise "Invalid resource, must be MD5/sha1/sha256/scan_id"
			end

			response = RestClient.post REPORT_URL, :apikey => api_key, :resource => resource
			
			case response.code
				when 429
					raise "Virustotal limit reached. Try again later."
				when 403
					raise "Invalid privileges, please check your API key."
				when 200
					JSON.parse(response)
				when 500
					nil
			end
		end
		
		# Submits a file to Virustotal.com for analysis
		# 
		# @param api_key Virustotal.com API key
		# @param path_to_file Path to file on disk to upload
		#
		# @return [JSON] Parsed response
		def self.scan_file(api_key, path_to_file)		
			if !File.exists?(path_to_file)
				raise Errno::ENOENT
			end
			
			if api_key == nil
				raise "Invalid API Key"
			end
				
			response = RestClient.post SCAN_URL, :apikey => api_key, :filename=> path_to_file, :file => File.new(path_to_file, 'rb')
			
			case response.code
				when 429
					raise "Virustotal limit reached. Try again later."
				when 403
					raise "Invalid privileges, please check your API key."
				when 200
					JSON.parse(response)
				else
					raise "Unknown Server error."
			end
		end
	end
end
