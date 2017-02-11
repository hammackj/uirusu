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
		def self.scan_url api_key, resource
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end

			params = {
				apikey: api_key,
				url: resource
			}

			Uirusu.query_api SCAN_URL, params, true
		end

		# Searches reports by URL from Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource url to search
		#
		# @return [JSON] Parsed response
		def self.query_report api_key, resource, **args
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end

			params = {
				apikey: api_key,
				resource: resource
			}

			Uirusu.query_api REPORT_URL, params.merge!(args), true
		end

		# Searches reports by URL from Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource url to search
		#
		# @return [JSON] Parsed response
		def self.feed(api_key, resource, **args)
			raise "#feed not yet implemented. This API call is only available to users that have licensed the unlimited tier of VirusTotal private Mass API."
		end
	end
end
