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

require 'test_helper'

class VTFileTest < Minitest::Test

  # Runs before each test, silences STDOUT/STDERR during the test
	def setup
    @original_stderr = $stderr
    @original_stdout = $stdout

    #$stderr = File.open(File::NULL, "w")
    ##$stdout = File.open(File::NULL, "w")

		@app_test = Uirusu::CLI::Application.new
    @app_test.load_config
	end

  # Restore STDOUT/STDERR after each test
  def teardown
    $stderr = @original_stderr
    $stdout = @original_stdout
  end

  def test_return_XX_results_for_hash_FD287794107630FA3116800E617466A9
    if @app_test.config['virustotal']['api-key'] == nil
      skip
    end

    hash = "FD287794107630FA3116800E617466A9" #Hash for a version of Poison Ivy

    results = Uirusu::VTFile.query_report(@app_test.config['virustotal']['api-key'], hash)
    result = Uirusu::VTResult.new(hash, results)

    assert_equal 56, result.results.size
  end
end
