# Copyright (c) 2010-2016 Arxopia LLC.
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
