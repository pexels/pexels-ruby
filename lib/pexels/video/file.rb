class Pexels::Video::File
  attr_reader :id,
              :quality,
              :file_type,
              :width,
              :height,
              :link

  def initialize(attrs)
    @id = attrs.fetch('id')
    @quality = attrs.fetch('quality')
    @file_type = attrs.fetch('file_type')
    @width = attrs.fetch('width')
    @height = attrs.fetch('height')
    @link = attrs.fetch('link')
  end
end
