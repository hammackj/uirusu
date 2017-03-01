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

require 'test_helper'

class VTUrlTest < Minitest::Test

	# Runs before each test, silences STDOUT/STDERR during the test
	def setup
		@original_stderr = $stderr
		@original_stdout = $stdout

		$stderr = File.open(File::NULL, "w")
		$stdout = File.open(File::NULL, "w")

		@app_test = Uirusu::CLI::Application.new
		@app_test.load_config if File.exist?(Uirusu::CONFIG_FILE)
	end

	# Restore STDOUT/STDERR after each test
	def teardown
		$stderr = @original_stderr
		$stdout = @original_stdout
	end

	def test_return_65_results_for_url_google_com
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil
			skip
		end

		url = "http://www.google.com"

		results = Uirusu::VTUrl.query_report(@app_test.config['virustotal']['api-key'], url)
		result = Uirusu::VTResult.new(url, results)

		assert_equal 65, result.results.size
	end

	def test_submit_single_url
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil
			skip
		end

		url = "http://www.google.com"

		results = Uirusu::VTUrl.scan_url(@app_test.config['virustotal']['api-key'], url)
		assert_equal 1, results["response_code"]
	end

	def test_submit_multiple_urls
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil
			skip
		end

		urls = ["http://www.google.com", "http://www.cnn.com", "http://www.npr.com", "http://hammackj.com"]

		results = Uirusu::VTUrl.scan_url(@app_test.config['virustotal']['api-key'], urls.join("\n"))

		results.each do |result|
			assert_equal 1, result["response_code"]
		end
	end

	def test_return_additional_info_for_url_google_com
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil || !@app_test.config['virustotal']['private']
			skip  'url additional_info private-api'
		end

		url = "http://www.google.com"

		results = Uirusu::VTUrl.query_report(@app_test.config['virustotal']['api-key'], url, allinfo: 1)

		assert_includes results.keys, "additional_info"
	end
end
