module Uirusu
	#
	#
	module VTUrl
		SCAN_URL = "https://www.virustotal.com/vtapi/v2/url/scan"
		REPORT_URL = "http://www.virustotal.com/vtapi/v2/url/report"
		
		# Submits a URL to be scanned by Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource url to submit
		#
		# @return [JSON] Parsed response
		def self.scan_url(api_key, resource)
			if api_key == nil
				raise "Invalid API Key"
			end
			
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end
			
			response = RestClient.post SCAN_URL, :apikey => api_key, :url => resource
			
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
		
		# Searchs reports by URL from Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource url to search
		#
		# @return [JSON] Parsed response
		def self.query_report(api_key, resource)
			if api_key == nil
				raise "Invalid API Key"
			end
			
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end
			
			response = RestClient.post REPORT_URL, :apikey => api_key, :resource => resource
			
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