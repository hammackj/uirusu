# uirusu

[![Gem Version](https://badge.fury.io/rb/uirusu.png)](http://badge.fury.io/rb/uirusu) [![Build Status](https://travis-ci.org/hammackj/uirusu.svg)](https://travis-ci.org/hammackj/uirusu) [![Code Climate](https://codeclimate.com/github/hammackj/uirusu/badges/gpa.svg)](https://codeclimate.com/github/hammackj/uirusu) [![Inline docs](http://inch-ci.org/github/hammackj/uirusu.svg?branch=master)](http://inch-ci.org/github/hammackj/uirusu)

uirusu is an [Virustotal](http://www.virustotal.com) automation and convenience tool for hash, file and URL submission.

The current version is 1.1.0.

## Requirements

* ruby 2.4+
* json
* rest-client
* **public api key from [virustotal.com](http://www.virustotal.com)**

## Installation

	% gem install uirusu
	% uirusu [options]

### Create your configuration file
	% uirusu --create-config

### Edit your configuration file with API key
	% $EDITOR ~/.uirusu

### Alternatively you can set Environment variables without a config file
	% export UIRUSU_VT_API_KEY=<YOUR_KEY_HERE>
	% export UIRUSU_VT_TIMEOUT=25

## Usage

### Searching a file of hashes

	% uirusu -f <file_with_hashes_one_per_line>

### Searching a single hash

	% uirusu -h FD287794107630FA3116800E617466A9

### Searching a file of hashes and outputting to XML
	% uirusu -f <file_with_hashes_one_per_line> -x

### Upload a file to Virustotal and wait for analysis
	% uirusu -u </path/to/file>

### Search for a single URL
	% uirusu -s "http://www.google.com"

### Saving results to a file
	% uirusu -s "http://www.google.com" --yaml-output > file.yaml

### Scan a directory and have them searched and save the results as json
	% uirusu -d /bin/ --json-output > file.json

## API Usage
```ruby
#First you need to include the correct require files
require 'uirusu'

API_KEY = "YOUR API KEY HERE"

hash = "FD287794107630FA3116800E617466A9" #Hash for a version of Poison Ivy
url = "http://www.google.com"
comment = "Hey this is Poison Ivy, anyone have a copy of this binary?"

#To query a hash(sha1/sha256/md5)
results = Uirusu::VTFile.query_report(API_KEY, hash)
result = Uirusu::VTResult.new(hash, results)
print result.to_stdout if result != nil

#To scan for a url
results = Uirusu::VTUrl.query_report(API_KEY, url)
result = Uirusu::VTResult.new(url, results)
print result.to_stdout if result != nil

#To post a comment to a resource(url/hash/scan_id)
results = Uirusu::VTComment.post_comment(API_KEY, hash, comment)
print results if results != nil
```

### Private API Support
Private API support is supported by the gem, but is not yet supported in the CLI application.

Notes:
* Details on the private API can be found [here](https://www.virustotal.com/en/documentation/private-api)
* Optional parameters can be sent to the method calls as named parameters (see VTFile#query_report below)
* #feed and #false_positive are currently not supported, as they require a special API key

#### Examples
Below are some examples specific to the private API.

##### Files
```ruby
# Search for a hash and get additional metadata
Uirusu::VTFile.query_report(API_KEY, hash, allinfo: 1)

# Get a file upload URL for larger files
Uirusu::VTFile.scan_upload_url(API_KEY)

# Submit a file with a callback URL
Uirusu::VTFile.scan_file(API_KEY, filepath, notify_url: 'http://requestb.in/117n0hb1')

# Request a behavioural report on a hash
Uirusu::VTFile.behaviour(API_KEY, hash)

# Request a network traffic report on a hash
Uirusu::VTFile.network_traffic(API_KEY, hash)
```

##### Domains and IPs
```ruby

# Get a report for a domain
Uirusu::VTDomain.query_report(API_KEY, domain)

# Get a report for an IP address
Uirusu::VTIPAddr.query_report(API_KEY, ip)
```

##License
Uirusu is licensed under the MIT license see the `LICENSE` file for the full license.

## Contact
You can reach the team at jacob.hammack[@]hammackj[dot]com, http://www.hammackj.com, or contact hammackj
