require 'minitest/autorun'
require 'pexels'

class TestVideo < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @video = @client.videos.search('test', per_page: 1).first
  end

  def test_successful_searches
    search_result = @client.videos.search('test')

    assert_kind_of Pexels::VideoSet, search_result
    assert_kind_of Pexels::VideoSet, search_result.next_page
    assert_kind_of Integer, search_result.total_results
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.videos.is_a? Array
    assert search_result.videos.any?
    assert search_result.first.is_a? Pexels::Video

    search_result_with_params = @client.videos.search('test', per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.videos.length, 1
    assert_kind_of Pexels::VideoSet, search_result_with_params.prev_page
  end

  def test_popular_videos
    search_result = @client.videos.popular

    assert_kind_of Pexels::VideoSet, search_result
    assert_kind_of Pexels::VideoSet, search_result.next_page
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.videos.is_a? Array
    assert search_result.videos.any?
    assert search_result.first.is_a? Pexels::Video

    search_result_with_params = @client.videos.popular(per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.videos.length, 1
    assert_kind_of Pexels::VideoSet, search_result_with_params.prev_page
  end

  def test_get_video
    video = @client.videos[@video.id]

    assert video.is_a? Pexels::Video

    assert_equal video.id, @video.id
    assert_equal video.width, @video.width
    assert_equal video.height, @video.height
    assert_equal video.url, @video.url

    assert video.video?
    assert_equal video.type, 'Video'
    refute video.photo?

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
    error = assert_raises(Pexels::APIError) do
      @client.videos['this-is-not-a-valid-id']
    end
    assert_equal 'Not Found', error.message
  end

  def test_invalid_orientation
    error = assert_raises(ArgumentError) do
      @client.photos.search('dog', orientation: 'foo')
    end
    assert_match '`orientation` must be one of', error.message
  end

  def test_invalid_size
    error = assert_raises(ArgumentError) do
      @client.photos.search('dog', size: 'foo')
    end
    assert_match '`size` must be one of', error.message
  end

  def test_search_filters
    search_result = @client.videos.search('cat', size: :medium, orientation: :square)
    assert_kind_of Pexels::VideoSet, search_result
    assert search_result.videos.any?
  end

  def test_get_video_open_timeout
    error = assert_raises Pexels::APIError do
      @client.videos[@video.id, timeout: { open: 0.0000001 }]
    end

    assert_equal 'execution expired', error.message
  end

  def test_get_video_read_timeout
    error = assert_raises Pexels::APIError do
      @client.videos[@video.id, timeout: { read: 0.0000001 }]
    end

    assert_equal 'Net::ReadTimeout', error.message
  end

  def test_search_open_timeout
    error = assert_raises Pexels::APIError do
      @client.videos.search('cat', timeout: { open: 0.0000001 })
    end

    assert_equal 'execution expired', error.message
  end

  def test_search_read_timeout
    error = assert_raises Pexels::APIError do
      @client.videos.search('cat', timeout: { read: 0.0000001 })
    end

    assert_equal 'Net::ReadTimeout', error.message
  end

  def test_featured_open_timeout
    error = assert_raises Pexels::APIError do
      @client.videos.popular(timeout: { open: 0.0000001 })
    end

    assert_equal 'execution expired', error.message
  end

  def test_featured_read_timeout
    error = assert_raises Pexels::APIError do
      @client.videos.popular(timeout: { read: 0.0000001 })
    end

    assert_equal 'Net::ReadTimeout', error.message
  end
end
