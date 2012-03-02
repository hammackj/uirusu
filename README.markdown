# uirusu

uirusu is [virustotal](http://www.virustotal.com) automation and convenience tool for hash, file and URL submission.

The current version is 0.0.1

## Requirements

* ruby
* rubygems
* json
* rest-client

* **public api key from [virustotal.com](http://www.virustotal.com)**

## Installation

	% gem install uirusu
	% uirusu [options]

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

## Contact
You can reach me at Jacob[dot]Hammack[at]hammackj[dot]com or http://www.hammackj.com
