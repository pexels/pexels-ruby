# Pexels Ruby Library

The Pexels Ruby library is a convenient wrapper around the Pexels API that you can use to browse the incredible content uploaded by our talented contributors.

## Installation

```
gem install pexels
```

Or add it to your `Gemfile` and run `bundle install`.

## Documentation

See the API docs [here](https://www.pexels.com/api/documentation/?language=rb)


## Basic usage

### Create a client

```ruby
# If you don't specify one, the environment variable PEXELS_API_KEY is used by default
client = Pexels::Client.new('your-access-key')
```

### Search for photos

```ruby
client.photos.search('Cloud')
```

### Search for photos with filters

```ruby
client.photos.search('Dog', color: :yellow, size: :large, orientation: :square)
```

### Find a specific photo

```ruby
client.photos[2014422]
# or
client.photos.find(2014422)
```

### Browse curated photos

```ruby
client.photos.curated
```

### Search for videos

```ruby
client.videos.search('waves')
```

### Search for videos with filters

```ruby
client.videos.search('Beach', size: :medium, orientation: :landscape)
```

### Find a specific photo

```ruby
client.videos[2014422]
# or
client.videos.find(2014422)
```

### Browse popular videos

```ruby
client.videos.popular
```

### List all collections

Note: this is limited to collections belonging to the API user.

```ruby
client.collections.all
```

### Get all media for a collection

```ruby
client.collections['collection-id'].media
# or
client.collections.find('collection-id').media
```

You can also filter for only `photos` or `videos`.

```ruby
client.collections['collection-id', type: 'photos'].media
client.collections['collection-id', type: 'videos'].media
```

## Rate Limiting

After performing a request, you can access your remaining rate limit via the client.

```ruby
client.ratelimit_remaining
```

## Pagination

Requests that return multiple objects are paginated. You can pass in `page` and `per_page` options to these requests to get a specific page. You can also access the total number of results by accessing `total_results` on the response. 

Note: The Pexels API returns a maximum of 80 records for one request.

```ruby
response = client.photos.search('dog', page: 2, per_page: 50)
response.total_results #=> 1000
response.total_pages #= 20
```

If there are further pages, you can also paginate through the API client:

```ruby
response = client.photos.search('dog', page: 2, per_page: 50)
response.prev_page # queries page 1
response.next_page # queries page 3
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
