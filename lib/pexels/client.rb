module Pexels
  class Client
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

    def collections
      @collections ||= Pexels::Client::Collections.new(self)
    end

    def request(path, method: 'GET', params: {}, options: {})
      request = Request.new(api_key, path, method, params, options)
      request.call.tap do |response|
        @ratelimit_remaining = response.ratelimit_remaining
      end
    end
  end
end
