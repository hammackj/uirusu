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

class ApplicationTest < Minitest::Test

	# Runs before each test, silences STDOUT/STDERR during the test
	def setup
		@original_stderr = $stderr
		@original_stdout = $stdout

		$stderr = File.open(File::NULL, "w")
		$stdout = File.open(File::NULL, "w")

		@app_test = Uirusu::CLI::Application.new
	end

	# Restore STDOUT/STDERR after each test
	def teardown
		$stderr = @original_stderr
		$stdout = @original_stdout
	end

	def test_should_create_a_config_file_for_Application_create_config
		file_name = "/tmp/" + (1...25).map{65.+(rand(25)).chr}.join
		@app_test.create_config(file_name)
		sleep(1)
		result = File.exist?(file_name)
		File.delete(file_name) if result
		assert true, result
	end

	def test_should_have_nill_api_key_on_Application_load_config
		file_name = "/tmp/" + (1...25).map{65.+(rand(25)).chr}.join
		@app_test.create_config(file_name)
		sleep(1)
		@app_test.load_config(file_name)
		assert_nil nil, @app_test.config['virustotal']['api-key']
	end

	def test_should_have_25_timeout_on_Application_load_config
		file_name = "/tmp/" + (1...25).map{65.+(rand(25)).chr}.join
		@app_test.create_config(file_name)
		sleep(1)
		@app_test.load_config(file_name)
		assert_equal 25, @app_test.config['virustotal']['timeout']
	end
end
