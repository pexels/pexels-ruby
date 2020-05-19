class Pexels::Response
  attr_reader :photos,
              :videos,
              :total_results,
              :page,
              :per_page,
              :next_page

  def initialize(attrs, type: :Photo)
    @total_results = attrs.fetch('total_results', nil)
    @page = attrs.fetch('page')
    @per_page = attrs.fetch('per_page')
    @next_page = attrs.fetch('next_page', nil)

    @photos = attrs.fetch('photos', []).map { |attrs| Pexels::Photo.new(attrs) }
    @videos = attrs.fetch('videos', []).map { |attrs| Pexels::Video.new(attrs) }

    return self
  end
end
