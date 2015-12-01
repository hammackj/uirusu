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
	module CLI
		class Application

			attr_accessor :config

			# Creates a new instance of the [Application] class
			#
			def initialize
				@options = {}
				@config = {}
				@hashes = Array.new
				@files_of_hashes = Array.new
				@sites = Array.new
				@uploads = Array.new
			end

			# Parses the command the line options and returns the parsed options hash
			#
			# @return [Hash] of the parsed options
			def parse_options(args)
				begin
					@options['output']  = :stdout
					@options['verbose'] = false
					@options['rescan']  = false
					@options[:timeout]  = 25
					@options[:directory] = nil

					opt = OptionParser.new do |opt|
						opt.banner = "#{APP_NAME} v#{VERSION}\nJacob Hammack\n#{HOME_PAGE}\n\n"
						opt.banner << "Usage: #{APP_NAME} <options>"
						opt.separator('')
						opt.separator('File Options')

						opt.on('-h HASH', '--search-hash HASH', 'Searches a single hash on virustotal.com') do |hash|
							@hashes.push(hash)
						end

						opt.on('-r HASH[,HASH]', '--rescan-hash HASH[,HASH]', 'Requests a rescan of a single hash, or multiple hashes (comma separated), by virustotal.com') do |hash|
							@options['rescan'] = true
							@hashes.push(hash)
						end

						opt.on('-f FILE', '--search-hash-file FILE', 'Searches each hash in a file of hashes on virustotal.com') do |file|
							if File.exists?(file)
								puts "[+] Adding file #{file}" if @options['verbose']
								@files_of_hashes.push(file)
							else
								puts "[!] #{file} does not exist, please check your input!\n"
							end
						end

						opt.on('-u FILE', '--upload-file FILE', 'Uploads a file to virustotal.com for analysis') do |file|
							if File.exists?(file)
								puts "[+] Adding file #{file}" if @options['verbose']
								@uploads.push(file)
							else
								puts "[!] #{file} does not exist, please check your input!\n"
							end
						end

						opt.separator('')
						opt.separator("Url Options")

						opt.on('-s SITE', '--search-site SITE', 'Searches for a single url on virustotal.com') { |site|
							@sites.push(site)
						}

						opt.separator('')
						opt.separator('Output Options')

						opt.on('-j', '--json-output', 'Print results as json to stdout') do
							@options['output'] = :json
						end

						opt.on('-x', '--xml-output', 'Print results as xml to stdout') do
							@options['output'] = :xml
						end

						opt.on('-y', '--yaml-output', 'Print results as yaml to stdout') do
							@options['output'] = :yaml
						end

						opt.on('--stdout-output', 'Print results as normal text line to stdout, this is default') do
							@options['output'] = :stdout
						end

						opt.separator ''
						opt.separator 'Advanced Options'

						opt.on('-c', '--create-config', 'Creates a skeleton config file to use') do
							create_config
							exit
						end

						opt.on('-d DIRECTORY', '--directory', 'Scans a directory recursively for files and submits the hashes') do |directory|
							@options[:directory] = directory
						end

						opt.on('-p PROXY', '--proxy-server', 'Uses a specified proxy server') do |proxy|
							@options['proxy'] = proxy
						end

						opt.on('--[no-]verbose', 'Print verbose information') do |v|
							@options['verbose'] = v
						end

						opt.separator ''
						opt.separator 'Other Options'

						opt.on('-v', '--version', 'Shows application version information') do
							puts "#{APP_NAME} - #{VERSION}"
							exit
						end

						opt.on_tail('-?', '--help', 'Show this message') { |help|
							puts opt.to_s + "\n"
							exit
						}
					end

				  if ARGV.length != 0
				    opt.parse!
				  else
				    puts opt.to_s + "\n"
					  exit
					end
				rescue OptionParser::MissingArgument => m
					puts opt.to_s + "\n"
					exit
				end
			end

			# Create config skeleton
			#
			def create_config (file=CONFIG_FILE)
				f = File.expand_path(file)

				if File.exists?(f) == false
					File.open(f, 'w+') do |f|
						f.write("virustotal: \n  api-key: \n  timeout: 25\n\n")
					end
					puts "[*] An empty #{f} has been created. Please edit and fill in the correct values."
				else
					puts "[!]  #{f} already exists. Please delete it if you wish to re-create it."
				end
			end

			# Loads the .uirusu config file for the api key
			#
			def load_config (file=CONFIG_FILE)
				f = File.expand_path(file)

				if File.exists?(f)
					@config = YAML.load_file f
				else
					STDERR.puts "[!] #{CONFIG_FILE} does not exist. Please run #{APP_NAME} --create-config, to create it."
					exit
				end

				@options[:timeout] = @config['virustotal']['timeout'] if @config['virustotal']['timeout'] != nil
			end

			# Submits a file/url and waits for analysis to be complete and returns the results.
			#
			# @param mod
			# @param resource
			# @param attempts
			#
			def scan_and_wait(mod, resource, attempts)
				method = nil
				retries = attempts

				if mod.name == "Uirusu::VTFile"
					STDERR.puts "[*] Attempting to rescan #{resource}" if  @options['verbose']
					method = @options['rescan'] ? mod.method(:rescan_file) : mod.method(:scan_file)
				else
					STDERR.puts "[*] Attempting to upload file #{resource}" if  @options['verbose']
					method = mod.method :scan_url
				end

				begin
					result = method.call(@config['virustotal']['api-key'], resource)
				rescue => e
					if @options['rescan']
						STDERR.puts "[!] An error has occurred with the rescan request.  Retrying 60 seconds up #{retries} retries: #{e.message}\n" if  @options['verbose']
					else
						STDERR.puts "[!] An error has occurred uploading the file. Retrying 60 seconds up #{retries} retries.\n" if  @options['verbose']
					end

					if retries >= 0
						sleep 60
						retry
						retries = retries - 1
					end
				end

				begin

					# Convert all single result replies to an array.  This is because
					# rescan_file returns an array of results if more than one hash
					# is requested to be rescanned.
					result_array = result.is_a?(Array) ? result : [ result ]

					result_array.collect do |result|
						if result['response_code'] == 1
							STDERR.puts "[*] Attempting to parse the results for: #{result['resource']}" if @options['verbose']
							results = mod.query_report(@config['virustotal']['api-key'], result['resource'])

							while results['response_code'] != 1
								STDERR.puts "[*] File has not been analyized yet, waiting 60 seconds to try again" if  @options['verbose']
								sleep 60
								results = mod.query_report(@config['virustotal']['api-key'], result['resource'])
							end

							return result['resource'], results

						elsif result['response_code'] == 0 and @options['rescan']
							STDERR.puts "[!] Unknown Virustotal error for rescan of #{result['resource']}." if @options['verbose']
							next

						elsif result['response_code'] == -1 and @options['rescan']
							STDERR.puts "[!] Virustotal does not have a sample of #{result['resource']}." if @options['verbose']
							next

						elsif result['response_code'] == -2
							STDERR.puts "[!] Virustotal limits exceeded, ***do not edit the timeout values.***"
							exit(1)
						else
							nil
						end
					end
				rescue => e
					STDERR.puts "[!] An error has occurred retrieving the report. Retrying 60 seconds up #{retries} retries. #{e.message}\n" if  @options['verbose']
					if retries >= 0
						sleep 60
						retry
						retries = retries - 1
					end
				end
			end

			#
			#
			def main(args)
				parse_options(args)
				load_config

				if @options['output'] == :stdout
					output_method = :to_stdout
				elsif @options['output'] == :json
					output_method = :to_json
				elsif @options['output'] == :yaml
					output_method = :to_yaml
				elsif @options['output'] == :xml
					output_method = :to_xml
				end

				if @options['proxy'] != nil
					RestClient.proxy = @options['proxy']
				end

				if @options[:directory] != nil
					hashes = Uirusu::Scanner.scan(@options[:directory])

					hashes.each do |hash|
						@hashes.push hash
					end
				end

				if @files_of_hashes != nil
					@files_of_hashes.each do |file|
						f = File.open(file, 'r')

						f.each do |hash|
							hash.chomp!
							@hashes.push hash
						end
					end
				end

				if @hashes != nil
					@hashes.each_with_index do |hash, index|
						if @options['rescan']
							results = scan_and_wait(Uirusu::VTFile, hash, 5)
						else
							results = Uirusu::VTFile.query_report(@config['virustotal']['api-key'], hash)
						end

						result = Uirusu::VTResult.new(hash, results)
						print result.send output_method if result != nil
						sleep @options[:timeout] if index != @hashes.length - 1
					end
				end

				if @sites != nil
					@sites.each_with_index do |url, index|
						results = scan_and_wait(Uirusu::VTUrl, url, 5)
						result = Uirusu::VTResult.new(results[0], results[1])
						print result.send output_method if result != nil
						sleep @options[:timeout] if index != @sites.length - 1
					end
				end

				if @uploads != nil
					@uploads.each_with_index do |upload, index|
						results = scan_and_wait(Uirusu::VTFile, upload, 5)
						result = Uirusu::VTResult.new(results[0], results[1])
						print result.send output_method if result != nil
						sleep @options[:timeout] if index != @uploads.length - 1
					end
				end
			end
		end
	end
end
