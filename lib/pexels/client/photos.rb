module Pexels
  class Client
    class Photos
      include SearchFilters

      def initialize(client)
        @client = client
      end

      def [](id, timeout: { open: nil, read: nil })
        response = @client.request(
          "#{Pexels.api_version}/photos/#{id}",
          options: { open_timeout: timeout[:open], read_timeout: timeout[:read] }
        )
        Pexels::Photo.new(response.body)
      end
      alias_method :find, :[]

      def search(query, per_page: 15, page: 1, locale: 'en-US', orientation: nil, size: nil, color: nil, timeout: { open: nil, read: nil })
        validate_search_params(orientation, size, color)

        response = @client.request(
          "#{Pexels.api_version}/search",
          params: {
            query: query,
            per_page: per_page,
            page: page,
            locale: locale,
            orientation: orientation,
            size: size,
            color: color
          }.compact,
          options: {
            open_timeout: timeout[:open],
            read_timeout: timeout[:read]
          }
        )

        Pexels::PhotoSet.new(response)
      end

      def curated(per_page: 15, page: 1, timeout: { open: nil, read: nil })
        response = @client.request(
          "#{Pexels.api_version}/curated",
          params: {
            per_page: per_page,
            page: page
          },
          options: {
            open_timeout: timeout[:open],
            read_timeout: timeout[:read]
          }
        )

        Pexels::PhotoSet.new(response)
      end

      private

      def validate_search_params(orientation, size, color)
        validate_orientation(orientation) &&
          validate_size(size) &&
          validate_color(color)
      end
    end
  end
end
