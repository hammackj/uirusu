# News

# 0.0.10 (December XX, 2016)
- Initial work on adding unit tests

# 0.0.9 (Novemeber 22, 2015)
- Adds empty options hash as arg to to_json override [kitplummer]

# 0.0.8 (Novemeber 20, 2015)
- Remove double array bracket [kitplummer]

# 0.0.7 (August 31, 2015)
- Accept HTTP response code 204 as limit-reached code [JasonPoll]
- Update application.rb [david-sackmary]

# 0.0.6 (September 10, 2013)
- Added support for hashing a directory and submitting it to the hash scan[request from myne-us]
	- -d DIRECTORY will invoke this, all files will be hashed and submitted to the hash array to be hashed
- Minor tweaks
	- Fixed the lack of a hash on 'file not found' results

# 0.0.5 (June 14, 2013)
- Merged Pull request from [jfx41]
- Lots of cleanup from [jfx41]

# 0.0.4 (April 11, 2013)
- Added Proxy support [abenson]
- Copyright date updates
- Made sure each hash request waits for the timeout specified in the yaml file
- The default timeout is 15 seconds, by default virustotal.org only allows 4 requests per minute

# 0.0.3 (August 16, 2012)
- Gemspec fix

# 0.0.2 (March 2, 2012)
- Copyright fixes

# 0.0.1 (February 25, 2012)
- Rename ruby-virustotal/virustotal gem to uirusu, to prevent being sued.
- Complete rewrite of the gem
