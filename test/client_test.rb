require 'minitest/autorun'
require 'pexels'

class TestClient < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
  end

  def test_ratelimit_remaining
    @client.photos.search('test')

    remaining = @client.ratelimit_remaining
    assert remaining.is_a? Integer
    assert remaining >= 0

    @client.photos.search('test')
    assert_equal @client.ratelimit_remaining, remaining - 1
  end

  def test_exceptions
    fake_request = Requests::Response.new(200, {}, ';')

    ::Requests.stub :request, fake_request do
      begin
        @client.photos.search('test')
        raise 'this shouldnt happen'
      rescue StandardError => exception
        assert_kind_of Pexels::APIError, exception
        assert exception.message != 'this shouldnt happen'
      end
    end
  end
end
