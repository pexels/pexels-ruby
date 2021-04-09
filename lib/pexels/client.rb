require 'requests'

class Pexels::Client
  attr_reader :api_key,
              :ratelimit_remaining


  def initialize(api_key = ENV['PEXELS_API_KEY'])
    @api_key = api_key
  end

  def photos
    @photos ||= Pexels::Client::Photos.new(self)
  end

  def videos
    @videos ||= Pexels::Client::Videos.new(self)
  end

  def request(path, method: 'GET', params: {})
    url = File.join(Pexels.api_base_url, path)
    puts "Requesting #{url}" if ENV['DEBUG']

    results = Requests.request(
      method,
      url,
      params: params,
      headers: {
        'Authorization' => api_key
      }
    )

    @ratelimit_remaining = results.headers['x-ratelimit-remaining'].first.to_i

    return JSON.parse(results.body)
  rescue StandardError => exception
    raise Pexels::APIError.new(exception)
  end
end

require 'pexels/client/photos'
require 'pexels/client/videos'
