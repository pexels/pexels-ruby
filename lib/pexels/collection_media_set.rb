module Pexels
  class CollectionMediaSet < PaginatedResponse
    alias_method :media, :data
    public :media

    attr_reader :id

    def initialize(attrs)
      super
      @id = attrs.fetch('id')
      @data = attrs.fetch('media', []).map do |attrs|
        if attrs['type'] == 'Photo'
          Pexels::Photo.new(attrs)
        elsif attrs['type'] == 'Video'
          Pexels::Video.new(attrs)
        end
      end

    rescue KeyError => exception
      raise Pexels::MalformedAPIResponseError.new(exception)
    end

    def photos
      @photos ||= media.select { |m| m.is_a?(Pexels::Photo) }
    end

    def videos
      @videos ||= media.select { |m| m.is_a?(Pexels::Video) }
    end
  end
end
