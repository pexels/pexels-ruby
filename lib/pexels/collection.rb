module Pexels
  class Collection
    attr_reader :id,
                :title,
                :description,
                :private,
                :media_count,
                :photos_count,
                :videos_count


    def initialize(attrs)
      @id = attrs.fetch('id')
      @title = attrs.fetch('title')
      @description = attrs.fetch('description')
      @private = attrs.fetch('private')
      @media_count = attrs.fetch('media_count')
      @photos_count = attrs.fetch('photos_count')
      @videos_count = attrs.fetch('videos_count')

    rescue KeyError => exception
      raise Pexels::MalformedAPIResponseError.new(exception)
    end
  end
end
