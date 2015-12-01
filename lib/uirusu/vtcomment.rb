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

module Uirusu
	# Module for submiting comments to Virustotal.com resources using the
	# Virustotal.com public API
	module VTComment
		POST_URL = Uirusu::VT_API + "/comments/put"

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
				when 429, 204
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
