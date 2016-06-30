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

	# Module for Accessing the File scan and report functionalities of the
	# Virustotal.com public API
	module VTFile
		SCAN_URL   = Uirusu::VT_API + "/file/scan"
		RESCAN_URL = Uirusu::VT_API + "/file/rescan"
		REPORT_URL = Uirusu::VT_API + "/file/report"

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
				raise "Invalid resource, must be md5/sha1/sha256/scan_id"
			end

			response = RestClient.post REPORT_URL, :apikey => api_key, :resource => resource

			case response.code
				when 429, 204
					raise "Virustotal limit reached. Try again later."
				when 403
					raise "Invalid privileges, please check your API key."
				when 200
					JSON.parse(response)
				when 500
					nil
				else
					raise "Unknown Server error."
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

		# Requests an existing file to be rescanned.
		#
		# @param api_key Virustotal.com API key
		# @param resource MD5/sha1/sha256/scan_id to rescan
		#
		# @return [JSON] Parsed response
		def self.rescan_file(api_key, resource)
			if api_key == nil
				raise "Invalid API Key"
			end

			if resource == nil
				raise "Invalid resource, must be md5/sha1/sha256/scan_id"
			end

			response = RestClient.post RESCAN_URL, :apikey => api_key, :resource => resource

			case response.code
				when 429, 204
					raise "Virustotal limit reached. Try again later."
				when 403
					raise "Invalid privileges, please check your API key."
				when 200
					JSON.parse(response)
				when 500
					nil
				else
					raise "Unknown Server error."
			end
		end
	end
end
