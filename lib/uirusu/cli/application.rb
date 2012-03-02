module Uirusu
	module CLI
		class Application
		
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
					@options['output'] = :stdout
					@options['verbose'] = false
				
					opt = OptionParser.new do |opt|
						opt.banner =	"#{APP_NAME} v#{VERSION}\nJacob Hammack\nhttp://www.hammackj.com\n\n"
						opt.banner << "Usage: #{APP_NAME} <options>"
						opt.separator('')
						opt.separator("File Options")
				
						opt.on('-h HASH', '--search-hash HASH', 'Searches a single hash on virustotal.com') do |hash| 
							@hashes.push(hash)
						end

						opt.on('-f FILE', '--search-hash-file FILE', 'Searches a each hash in a file of hashes on virustotal.com') do |file|
							if File.exists?(file)
								puts "[+] Adding file #{file}" if @options["verbose"]
								@files_of_hashes.push(file)
							else
								puts "[!] #{file} does not exist, please check your input!\n"
							end
						end
					
						opt.on('-u FILE', '--upload-file FILE', 'Uploads a file to virustotal.com for analysis') do |file|
							if File.exists?(file)
								puts "[+] Adding file #{file}" if @options["verbose"]
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

						opt.on('-x', '--xml-output', 'Print results as xml to stdout') do
							@options["output"] = :xml
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
							if File.exists?(File.expand_path(CONFIG_FILE)) == false
								File.open(File.expand_path(CONFIG_FILE), 'w+') do |f| 
									f.write("virustotal: \n  api-key: \n  timeout: 25\n\n") 
								end

								puts "[*] An empty #{File.expand_path(CONFIG_FILE)} has been created. Please edit and fill in the correct values."
								exit
							else
								puts "[!]  #{File.expand_path(CONFIG_FILE)} already exists. Please delete it if you wish to re-create it."
								exit
							end
						end

						opt.on('--[no-]verbose', 'Print verbose information') do |v|
							@options["verbose"] = v
						end
				
						opt.separator ''
						opt.separator 'Other Options'
				
						opt.on('-v', '--version', "Shows application version information") do
							puts "#{APP_NAME} - #{VERSION}"
							exit
						end

						opt.on_tail("-?", "--help", "Show this message") { |help|
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
			
			# Loads the .uirusu config file for the api key
			#
			def load_config
				if File.exists?(File.expand_path(CONFIG_FILE))
					@config = YAML.load_file File.expand_path(CONFIG_FILE)
				else
					STDERR.puts "[!] #{CONFIG_FILE} does not exist. Please run #{APP_NAME} --create-config, to create it."
					exit
				end
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
					method = mod.method :scan_file
				else
					method = mod.method :scan_url
				end

				begin
					STDERR.puts "[*] Attempting to upload file #{resource}" if  @options["verbose"]
					result = method.call(@config["virustotal"]["api-key"], resource)					
				rescue => e
					STDERR.puts "[!] An error has occured uploading the file. Retrying 60 seconds up #{retries} retries.\n" if  @options["verbose"]
					if retries >= 0
						sleep 60
						retry
						retries = retries - 1
					end
				end
				
				begin
					if result['response_code']	== 1
						results = mod.query_report(@config["virustotal"]["api-key"], result['resource'])
						
						while results["response_code"] != 1
							STDERR.puts "[*] File has not been analyized yet, waiting 60 seconds to try again" if  @options["verbose"]
							sleep 60				
							results = mod.query_report(@config["virustotal"]["api-key"], result['resource'])
						end
					
						return [result['resource'], results]
					elsif result['response_code']	== -2
						STDERR.puts "[!] Virustotal limits exceeded, ***do not edit the timeout values.***" 
						exit(1)
					else
						nil
					end	
				rescue => e					
					STDERR.puts "[!] An error has occured retrieving the report. Retrying 60 seconds up #{retries} retries.\n" if  @options["verbose"]
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
				elsif @options['output'] == :yaml
					output_method = :to_yaml
				elsif @options['output'] == :xml
					output_method = :to_xml
					print "<results>\n"
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
					@hashes.each do |hash|
						result = Uirusu::VTFile.query_report(@config["virustotal"]["api-key"], hash)
						print result.send output_method if result != nil
					end
				end

				if @sites != nil
					@sites.each do |url|
						results = scan_and_wait(Uirusu::VTUrl, url, 5)
						result = Uirusu::VTResult.new(results[0], results[1])
						print result.send output_method if result != nil
					end
				end

				if @uploads != nil
					@uploads.each do |upload|
						results = scan_and_wait(Uirusu::VTFile, upload, 5)
						result = Uirusu::VTResult.new(results[0], results[1])						
						print result.send output_method if result != nil
					end
				end

				if @options['output'] == :xml
					print "</results>\n"
				end
			end
		end
	end
end