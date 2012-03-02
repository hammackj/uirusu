module Uirusu
	APP_NAME = "uirusu"
	VERSION = "0.0.1"
	CONFIG_FILE = "~/.uirusu"
end

require 'json'
require 'rest_client'
require 'optparse'
require 'yaml'

require 'uirusu/vtfile'
require 'uirusu/vturl'
require 'uirusu/vtcomment'
require 'uirusu/vtresult'
require 'uirusu/cli/application'