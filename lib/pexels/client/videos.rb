module Pexels
  class Client
    class Videos
      include SearchFilters

      def initialize(client)
        @client = client
      end

      def [](id)
        response = @client.request("/videos/videos/#{id}")
        Pexels::Video.new(response.body)
      end
      alias_method :find, :[]

      def search(query, per_page: 15, page: 1, orientation: nil, size: nil)
        validate_search_params(orientation, size)

        response = @client.request(
          '/videos/search',
          params: {
            query: query,
            per_page: per_page,
            page: page,
            orientation: orientation,
            size: size
          }.compact
        )

        Pexels::VideoSet.new(response)
      end

      def popular(per_page: 15, page: 1)
        response = @client.request(
          '/videos/popular',
          params: {
            per_page: per_page,
            page: page,
          }
        )

        Pexels::VideoSet.new(response)
      end

      private

      def validate_search_params(orientation, size)
        validate_orientation(orientation) &&
          validate_size(size)
      end
    end
  end
end
