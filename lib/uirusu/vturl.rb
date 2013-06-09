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
	#
	#
	module VTUrl
		SCAN_URL   = Uirusu::VT_API + "/url/scan"
		REPORT_URL = Uirusu::VT_API + "/url/report"

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

		# Searches reports by URL from Virustotal.com
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

