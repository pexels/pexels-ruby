require 'requests'

module Pexels
  class Client
    class Request
      attr_reader :api_key, :path, :method, :params

      def initialize(api_key, path, method, params)
        @api_key = api_key
        @path = path
        @method = method
        @params = params
      end

      def call
        log_request if ENV['DEBUG']

        Response.new(self, execute)

      rescue StandardError => exception
        raise Pexels::APIError.new(exception)
      end

      private

      def execute
        Requests.request(
          method,
          url,
          params: params,
          headers: headers
        )
      end

      def url
        @url ||= File.join(Pexels.api_base_url, path)
      end

      def headers
        @headers = {
          'Authorization' => api_key,
          'User-Agent' => "Pexels/Ruby (#{Pexels::VERSION})"
        }.merge(Pexels.local_headers)
      end

      def log_request
        puts "Requesting #{url}"
        puts " → params: #{params}"
        puts " → headers: #{headers}"
      end
    end
  end
end
