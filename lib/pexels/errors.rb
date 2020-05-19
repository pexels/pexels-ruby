module Pexels
  class APIError < StandardError; end
  class MalformedAPIResponseError < APIError; end
end
