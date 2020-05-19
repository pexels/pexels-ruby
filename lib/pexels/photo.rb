class Pexels::Photo
  attr_reader :id,
              :width,
              :height,
              :url,
              :user,
              :src


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

  rescue KeyError => exception
    raise Pexels::MalformedAPIResponseError.new(exception)
  end
end
