module Pexels
  class PhotoSet < PaginatedResponse
    alias_method :photos, :data
    public :photos

    def initialize(response)
      super
      @data = attrs.fetch('photos', []).map { |attrs| Pexels::Photo.new(attrs) }

    rescue KeyError => exception
      raise Pexels::MalformedAPIResponseError.new(exception)
    end
  end
end
