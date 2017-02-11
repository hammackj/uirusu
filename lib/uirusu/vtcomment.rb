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
	# Module for submiting comments to Virustotal.com resources using the
	# Virustotal.com public API
	module VTComment
		POST_URL = Uirusu::VT_API + "/comments/put"
		GET_URL = Uirusu::VT_API + "/comments/get"

		# Submits a comment to Virustotal.com for a specific resource
		#
		# @param [String] api_key Virustotal.com API key
		# @param [String] resource MD5/sha1/sha256/scan_id to search for
		# @param [String] comment Comment to post to the resource
		#
		# @return [JSON] Parsed response
		def self.post_comment(api_key, resource, comment)
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end

			if comment == nil
				raise "You must provide a comment to submit."
			end

			params = {
				apikey: api_key,
				resource: resource,
				comment: comment
			}
			Uirusu.query_api POST_URL, params
		end

		# Retrieve a list of comments to Virustotal.com for a specific resource
		#
		# @param [String] api_key Virustotal.com API key
		# @param [String] resource MD5/sha1/sha256/scan_id/URL to search for
		# @param [DateTime] before A datetime token that allows you to iterate over all comments on a specific item whenever it has been commented on more than 25 times
		#
		# @return [JSON] Parsed response
		def self.get_comments(api_key, resource, before=nil)
			if resource == nil
				raise "Invalid resource, must be a valid url"
			end

			params = {
				apikey: api_key,
				resource: resource
			}
			params[:before] = before unless before.nil?
			Uirusu.query_api GET_URL, params
		end
	end
end
