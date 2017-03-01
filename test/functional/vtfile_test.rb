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

class VTFileTest < Minitest::Test

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

	def test_return_XX_results_for_hash_FD287794107630FA3116800E617466A9
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil
			skip
		end

		hash = "FD287794107630FA3116800E617466A9" #Hash for a version of Poison Ivy

		results = Uirusu::VTFile.query_report(@app_test.config['virustotal']['api-key'], hash)
		result = Uirusu::VTResult.new(hash, results)

		assert_equal 55, result.results.size
	end

	def test_return_additional_info_for_hash_FD287794107630FA3116800E617466A9
		# Skip the test if we dont have a API key
		if @app_test.config.empty? || @app_test.config['virustotal']['api-key'] == nil || !@app_test.config['virustotal']['private']
			skip  'hash additional_info private-api'
		end

		hash = "FD287794107630FA3116800E617466A9" #Hash for a version of Poison Ivy

		results = Uirusu::VTFile.query_report(@app_test.config['virustotal']['api-key'], hash, allinfo: 1)

		assert_includes results.keys, "additional_info"
	end
end
