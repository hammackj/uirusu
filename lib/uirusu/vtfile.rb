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

	# Module for Accessing the File scan and report functionalities of the
	# Virustotal.com public API
	module VTFile
		SCAN_URL             = Uirusu::VT_API + "/file/scan"
		SCAN_UPLOAD_URL      = Uirusu::VT_API + "/file/scan/upload_url"
		RESCAN_URL           = Uirusu::VT_API + "/file/rescan"
		RESCAN_DELETE_URL    = Uirusu::VT_API + "/file/rescan/delete"
		REPORT_URL           = Uirusu::VT_API + "/file/report"
		BEHAVIOUR_URL        = Uirusu::VT_API + "/file/behaviour"
		NETWORK_TRAFFIC_URL	 = Uirusu::VT_API + "/file/network-traffic"
		SEARCH_URL           = Uirusu::VT_API + "/file/search"
		CLUSTERS_URL         = Uirusu::VT_API + "/file/clusters"
		DOWNLOAD_URL         = Uirusu::VT_API + "/file/download"
		FEED_URL             = Uirusu::VT_API + "/file/feed" #not implemented
		FALSE_POSITIVES_URL  = Uirusu::VT_API + "/file/false-positives" #not implemented


		# Queries a report from Virustotal.com
		#
		# @param api_key Virustotal.com API key
		# @param resource MD5/sha1/sha256/scan_id to search for
		# @params **args named arguments for optional parameters - https://www.virustotal.com/en/documentation/private-api/#get-report
		#
		# @return [JSON] Parsed response
		def VTFile.query_report(api_key, resource, **args)
			if resource == nil
				raise "Invalid resource, must be md5/sha1/sha256/scan_id"
			end

			params = {
				apikey: api_key,
				resource: resource
			}
			Uirusu.query_api REPORT_URL, params.merge!(args), true
		end

		# Submits a file to Virustotal.com for analysis
		#
		# @param api_key Virustotal.com API key
		# @param path_to_file Path to file on disk to upload
		# @params **args named arguments for optional parameters - https://www.virustotal.com/en/documentation/private-api/#scan
		#
		# @return [JSON] Parsed response
		def self.scan_file(api_key, path_to_file, **args)
			if !File.exist?(path_to_file)
				raise Errno::ENOENT
			end

			params = {
				apikey: api_key,
				filename: path_to_file,
				file: File.new(path_to_file, 'rb')
			}
			Uirusu.query_api SCAN_URL, params.merge!(args), true
		end

		# Retrieves a custom upload URL for files larger than 32MB
		#
		# @param api_key Virustotal.com API key
		#
		# @return [JSON] Parsed response
		def self.scan_upload_url(api_key)
			params = {
				apikey: api_key
			}
			Uirusu.query_api SCAN_UPLOAD_URL, params
		end

		# Requests an existing file to be rescanned.
		#
		# @param api_key Virustotal.com API key
		# @param resource MD5/sha1/sha256/scan_id to rescan
		# @params **args named arguments for optional parameters - https://www.virustotal.com/en/documentation/private-api/#rescan
		#
		# @return [JSON] Parsed response
		def self.rescan_file(api_key, resource, **args)
			if resource == nil
				raise "Invalid resource, must be md5/sha1/sha256/scan_id"
			end

			params = {
				apikey: api_key,
				resource: resource
			}
			Uirusu.query_api RESCAN_URL, params.merge!(args), true
		end

		# Deletes a scheduled rescan request.
		#
		# @param api_key Virustotal.com API key
		# @param resource MD5/sha1/sha256/scan_id to rescan
		#
		# @return [JSON] Parsed response
		def self.rescan_delete(api_key, resource)
			if resource == nil
				raise "Invalid resource, must be md5/sha1/sha256/scan_id"
			end

			params = {
				apikey: api_key,
				resource: resource
			}

			Uirusu.query_api RESCAN_DELETE_URL, params, true
		end

		# Requests a behavioural report on a hash.
		#
		# @param api_key Virustotal.com API key
		# @param hash MD5/sha1/sha256 to query
		#
		# @return [JSON] Parsed response
		def self.behaviour(api_key, hash)
			if hash == nil
				raise "Invalid hash, must be md5/sha1/sha256"
			end

			params = {
				apikey: api_key,
				hash: hash
			}
			Uirusu.query_api BEHAVIOUR_URL, params
		end

		# Requests a network traffic report on a hash.
		#
		# @param api_key Virustotal.com API key
		# @param hash MD5/sha1/sha256 to query
		#
		# @return [PCAP] A PCAP file containing the network traffic dump
		def self.network_traffic(api_key, hash)
			if hash == nil
				raise "Invalid hash, must be md5/sha1/sha256"
			end

			params = {
				apikey: api_key,
				hash: hash
			}
			Uirusu.query_api NETWORK_TRAFFIC_URL, params
		end

		# Perform an advanced reverse search.
		#
		# @param api_key Virustotal.com API key
		# @param query A search modifier compliant file search query (https://www.virustotal.com/intelligence/help/file-search/#search-modifiers)
		# @param **args named optional arguments - https://www.virustotal.com/en/documentation/private-api/#search
		#
		# @return [JSON] Parsed response
		def self.search(api_key, query, **args)
			if query == nil
				raise "Please enter a valid query."
			end

			params = {
				apikey: api_key,
				query: query
			}
			Uirusu.query_api SEARCH_URL, params.merge!(args)
		end

		# Access the clustering section of VT Intelligence.
		#
		# @param api_key Virustotal.com API key
		# @param date A specific day for which we want to access the clustering details, example: 2013-09-10
		#
		# @return [JSON] Parsed response
		def self.clusters(api_key, date)
			if date == nil
				raise "Please enter a valid date (Ex: 2013-09-10)"
			end

			params = {
				apikey: api_key,
				date: date
			}
			Uirusu.query_api CLUSTERS_URL, params
		end

		# Download a file from vT's store given a hash.
		#
		# @param api_key Virustotal.com API key
		# @param hash The md5/sha1/sha256 of the file you want to download
		#
		# @return [File] the downloaded file
		def self.download(api_key, hash)
			if hash == nil
				raise "Please enter a valid md5/sha1/sha256 hash"
			end

			params = {
				apikey: api_key,
				hash: hash
			}
			Uirusu.query_api DOWNLOAD_URL, params
		end

		# Retrieve a live feed of all uploaded files to VT.
		#
		# @param api_key Virustotal.com API key
		# @param package Indicates a time window to pull reports on all items received during such window. Only per-minute and hourly windows are allowed, the format is %Y%m%dT%H%M (e.g. 20160304T0900) or %Y%m%dT%H (e.g. 20160304T09). Time is expressed in UTC.
		#
		# @return [JSON] Parsed response
		def self.feed(api_key, package)
			raise "#false_positives not yet implemented. This API call is only available to users that have licensed the unlimited tier of VirusTotal private Mass API."
		end

		# Allows vendors to consume false positive notifications for files that they mistakenly detect.
		#
		# @param api_key Virustotal.com API key
		# @param limit The number of false positive notifications to consume, if available. The max value is 1000.
		#
		# @return [JSON] Parsed response
		def self.false_positives(api_key, limit=100)
			raise "#false_positives not yet implemented. This API is only available to antivirus vendors participating in VirusTotal."
		end
	end
end
