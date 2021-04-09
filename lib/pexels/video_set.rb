module Pexels
  class VideoSet < PaginatedResponse
    alias_method :videos, :data
    public :videos

    def initialize(attrs)
      super
      @data = attrs.fetch('videos', []).map { |attrs| Pexels::Video.new(attrs) }

    rescue KeyError => exception
      raise Pexels::MalformedAPIResponseError.new(exception)
    end
  end
end
