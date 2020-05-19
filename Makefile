test: .gems.up.to.date
	ruby -Ilib -e 'ARGV.each { |f| require f }' ./test/*.rb

.gems.up.to.date: .gems
	(which dep || gem install dep) && dep install && touch $@

console: .gems.up.to.date
	irb -r pexels

build: .gems.up.to.date
	gem build pexels.gemspec

all: test

.PHONY: test console build
