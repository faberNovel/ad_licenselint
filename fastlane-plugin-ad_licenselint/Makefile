build:
	gem build fastlane-plugin-ad_licenselint.gemspec

install: clean build
	gem install fastlane-plugin-ad_licenselint-*.gem

publish: clean build
	gem push fastlane-plugin-ad_licenselint-*.gem

clean:
	rm -f fastlane-plugin-ad_licenselint-*.gem

tests:
	bundle exec rake test