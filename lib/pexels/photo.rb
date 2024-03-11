class Pexels::Photo
  attr_reader :id,
              :width,
              :height,
              :url,
              :user,
              :src,
              :avg_color,
              :alt

  def initialize(attrs)
    @id = attrs.fetch('id')
    @height = attrs.fetch('height')
    @width = attrs.fetch('width')
    @url = attrs.fetch('url')
    @user = Pexels::User.new(
      id: attrs.fetch('photographer_id'),
      name: attrs.fetch('photographer'),
      url: attrs.fetch('photographer_url')
    )
    @src = attrs.fetch('src')
    @avg_color = attrs.fetch('avg_color')
    @alt = attrs.fetch('alt')
  rescue KeyError => exception
    raise Pexels::MalformedAPIResponseError.new(exception)
  end

  def type
    'Photo'
  end

  def photo?
    true
  end

  def video?
    false
  end
end
