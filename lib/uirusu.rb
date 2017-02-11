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
	CONFIG_FILE = "#{Dir.home}/.uirusu"
	VT_API = "https://www.virustotal.com/vtapi/v2"
	RESULT_FIELDS = [ :hash, :scanner, :version, :detected, :result, :md5, :sha1, :sha256, :update, :permalink ]

	protected
	# Queries the API using RestClient and parses the response.
	#
	# @param url [string] URL endpoint to send the request to
	# @param params [hash] Hash of HTTP params
	# @param post [boolean] (optional) Specifies whether to use POST or GET
	#
	# @return [JSON] Parsed response
	def self.query_api(url, params, post=false)
		if params[:apikey] == nil
			raise "Invalid API Key"
		end

		# TODO get options to here.
		#resource = RestClient::Resource.new(url, :verify_ssl=>false)
		resource = RestClient::Resource.new(url)

		begin
			if post
				#response = RestClient.post url, **params
				response = resource.post(params)
			else
				#response = RestClient.get url, params: params
				response = resource.get(params)
			end
		rescue => e
			response = e.response
		end

		self.parse_response response
	end

	# Parses the response or raises an exception accordingly.
	#
	# @param response The response from RestClient
	#
	# @return [JSON] Parsed response
	def self.parse_response(response)
		puts "Parse Response"
		begin
			case response.code
				when 429, 204
					raise "Virustotal limit reached. Try again later."
				when 403
					raise "Invalid privileges, please check your API key."
				when 200
					# attempt to parse it as json, otherwise return the raw response
					# network_traffic and download return non-JSON data
					begin
						JSON.parse(response)
					rescue
						response
					end
				when 500
					nil
				else
					raise "Unknown Server error. (#{response.code})"
			end
		end
	rescue => e
		puts e.message
	end
end

require 'json'
require 'rest-client'
require 'optparse'
require 'yaml'

require 'uirusu/version'
require 'uirusu/vtfile'
require 'uirusu/vturl'
require 'uirusu/vtipaddr'
require 'uirusu/vtdomain'
require 'uirusu/vtcomment'
require 'uirusu/vtresult'
require 'uirusu/scanner'
require 'uirusu/cli/application'
