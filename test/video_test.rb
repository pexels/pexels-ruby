require 'minitest/autorun'
require 'pexels'

class TestVideo < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @video = @client.videos.search('test', per_page: 1).videos.first
  end

  def test_successful_searches
    search_result = @client.videos.search('test')

    assert search_result.is_a? Pexels::Response
    assert search_result.total_results.is_a? Integer
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.videos.is_a? Array
    assert search_result.videos.any?
    assert search_result.videos.first.is_a? Pexels::Video

    search_result_with_params = @client.videos.search('test', per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.videos.length, 1
  end

  def test_popular_videos
    search_result = @client.videos.popular

    assert search_result.is_a? Pexels::Response
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.videos.is_a? Array
    assert search_result.videos.any?
    assert search_result.videos.first.is_a? Pexels::Video

    search_result_with_params = @client.videos.popular(per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.videos.length, 1
  end

  def test_get_video
    video = @client.videos.get(@video.id)

    assert video.is_a? Pexels::Video

    assert_equal video.id, @video.id
    assert_equal video.width, @video.width
    assert_equal video.height, @video.height
    assert_equal video.url, @video.url

    assert video.user.is_a?(Pexels::User)
    assert_equal video.user.name, @video.user.name
    assert_equal video.user.url, @video.user.url
    assert_equal video.user.id, @video.user.id

    assert video.files.is_a?(Array)
    assert video.files.first.is_a?(Pexels::Video::File)

    assert video.pictures.is_a?(Array)
    assert video.pictures.first.is_a?(Pexels::Video::Picture)
  end

  def test_invalid_get_video
    video = @client.videos.get('this-is-not-a-valid-id')
    raise 'This should not happen'
    rescue StandardError => exception
      assert exception.is_a? Pexels::APIError
      #assert_equal exception.message, 'Not Found'
      #
      ## This is incorrect  behavior from the API, which we should change
      #  once its fixed.
      assert_equal exception.message, 'Internal Server Error'
  end
end
