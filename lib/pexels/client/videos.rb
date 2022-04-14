module Pexels
  class Client
    class Videos
      include SearchFilters

      def initialize(client)
        @client = client
      end

      def [](id, timeout: { open: nil, read: nil })
        response = @client.request(
          "/videos/videos/#{id}",
          options: {
            open_timeout: timeout[:open],
            read_timeout: timeout[:read]
          }
        )
        Pexels::Video.new(response.body)
      end
      alias_method :find, :[]

      def search(query, per_page: 15, page: 1, orientation: nil, size: nil, timeout: { open: nil, read: nil })
        validate_search_params(orientation, size)

        response = @client.request(
          '/videos/search',
          params: {
            query: query,
            per_page: per_page,
            page: page,
            orientation: orientation,
            size: size
          }.compact,
          options: {
            open_timeout: timeout[:open],
            read_timeout: timeout[:read]
          }
        )

        Pexels::VideoSet.new(response)
      end

      def popular(per_page: 15, page: 1, timeout: { open: nil, read: nil })
        response = @client.request(
          '/videos/popular',
          params: {
            per_page: per_page,
            page: page
          },
          options: {
            open_timeout: timeout[:open],
            read_timeout: timeout[:read]
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
