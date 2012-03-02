module Uirusu
	# Module for submiting comments to Virustotal.com resources using the
	# Virustotal.com public API
	module VTComment
		POST_URL = "https://www.virustotal.com/vtapi/v2/comments/put"
		
		# Submits a comment to Virustotal.com for a specific resource
		#
		# @param [String] api_key Virustotal.com API key
		# @param [String] resource MD5/sha1/sha256/scan_id to search for
		# @param [String] comment Comment to post to the resource
		#
		# @return [JSON] Parsed response
		def self.post_comment(api_key, resource, comment)
			if api_key == nil
				raise "Invalid API Key"
			end
			
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end
			
			if comment == nil
				raise "You must provide a comment to submit."
			end
			
			response = RestClient.post POST_URL, :apikey => api_key, :resource => resource, :comment => comment
			
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
