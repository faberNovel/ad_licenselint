build:
	gem build ad_licenselint.gemspec

install: clean build
	gem install ad_licenselint-*.gem

clean:
	rm -f ad_licenselint-*.gem

tests:
	bundle exec rake test
