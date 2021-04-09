module Pexels
  @api_base_url = ENV['PEXELS_API_BASE_URL'] || 'https://api.pexels.com'
  @api_version = ENV['PEXELS_API_VERSION'] || 'v1'

  class << self
    attr_reader :api_base_url, :api_version
  end
end

require_relative 'pexels/client'
require_relative 'pexels/client/photos'
require_relative 'pexels/client/videos'
require_relative 'pexels/version'
require_relative 'pexels/errors'
require_relative 'pexels/photo'
require_relative 'pexels/video'
require_relative 'pexels/video/file'
require_relative 'pexels/video/picture'
require_relative 'pexels/user'
require_relative 'pexels/response'
