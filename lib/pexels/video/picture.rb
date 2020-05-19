class Pexels::Video::Picture
  attr_reader :id,
              :picture
              :nr

  def initialize(attrs)
    @id = attrs.fetch('id')
    @picture = attrs.fetch('picture')
    @nr = attrs.fetch('nr')
  end
end
