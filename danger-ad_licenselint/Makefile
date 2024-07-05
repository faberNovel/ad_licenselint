build:
	gem build danger-ad_licenselint.gemspec

install: clean build
	gem install danger-ad_licenselint-*.gem

publish: clean build
	gem push danger-ad_licenselint-*.gem

clean:
	rm -f danger-ad_licenselint-*.gem
