class Pexels::Video
  attr_reader :id,
              :width,
              :height,
              :url,
              :image,
              :duration,
              :user,
              :files,
              :pictures


  def initialize(attrs)
    @id = attrs.fetch('id')
    @height = attrs.fetch('height')
    @width = attrs.fetch('width')
    @url = attrs.fetch('url')
    @image = attrs.fetch('image')
    @duration = attrs.fetch('duration')
    @user = Pexels::User.new(
      id: attrs.fetch('user').fetch('id'),
      name: attrs.fetch('user').fetch('name'),
      url: attrs.fetch('user').fetch('url')
    )

    @files = attrs.fetch('video_files', []).map { |vf| Pexels::Video::File.new(vf) }

    @pictures = attrs.fetch('video_pictures', []).map { |vp| Pexels::Video::Picture.new(vp) }


  rescue KeyError => exception
    raise Pexels::MalformedAPIResponseError.new(exception)
  end

  def type
    'Video'
  end

  def photo?
    false
  end

  def video?
    true
  end
end
