# News

# 0.0.6 (September)
- Added support for hashing a directory and submitting it to the hash scan[request from myne-us]
	- -d DIRECTORY will invoke this, all files will be hashed and submitted to the hash array to be hashed
- Minor tweaks
	- Fixed the lack of a hash on 'file not found' results

# 0.0.5 (June 14, 2013)
- Merged Pull request from [jfx41]
- Lots of cleanup from jfx41

# 0.0.4 (April 11, 2013)
- Added Proxy support [abenson]
- Copyright date updates
- Made sure each hash request waits for the timeout specified in the yaml file
- The default timeout is 15 seconds, by default virustotal.org only allows 4 requests per minute

# 0.0.3 ()
- Gemspec fix

# 0.0.2 ()
- Copyright fixes

# 0.0.1 (March 4, 2012)
- Rename ruby-virustotal/virustotal gem to uirusu, to prevent being sued.
- Complete rewrite of the gem

