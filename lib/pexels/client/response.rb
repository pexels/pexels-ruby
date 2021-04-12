require 'requests'

module Pexels
  class Client
    class Response
      attr_reader :request, :response

      def initialize(request, response)
        @request = request
        @response = response
      end

      def body
        JSON.parse(response.body)

      rescue JSON::JSONError => exception
        raise Pexels::APIError.new(exception)
      end

      def headers
        response.headers
      end

      def ratelimit_remaining
        headers['x-ratelimit-remaining']&.first&.to_i
      end
    end
  end
end
