# Pexels Ruby Library

The Pexels Ruby library is a convenient wrapper around the Pexels API that you can use to browse the incredible content uploaded by our talented contributors.

## Installation

```
gem install pexels
```

Or add it to your `Gemfile` and run `bundle install`.

## Documentation

See the API docs [here](https://www.pexels.com/api/documentation/?language=js)


## Basic usage

```ruby
client = Pexels::Client.new('your-access-key') #=> If you don't specify one, the environment variable PEXELS_API_KEY is used by default

client.photos.search('Cloud')
client.photos.curated

client.videos.search('waves')
client.videos.popular
```

## Running the test suite

You'll need your own API key to run the test suite, you can get one on the [Pexels API Key management page](https://www.pexels.com/api/new/)

For ease of use, you'll probably want to copy the provided `.env.sample` into your own `.env` file and substitute the `PEXELS_API_KEY` variable with your own.

```
cp .env.sample .env
vim .env              #=> Change PEXELS_API_KEY
source .env           #=> Load the environment

make test
```
