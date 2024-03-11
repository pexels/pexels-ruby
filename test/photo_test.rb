require 'minitest/autorun'
require 'pexels'

class TestPhoto < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @photo = @client.photos.search('test', per_page: 1).first
  end

  def test_successful_searches
    search_result = @client.photos.search('test')

    assert_kind_of Pexels::PhotoSet, search_result
    assert_kind_of Pexels::PhotoSet, search_result.next_page
    assert_kind_of Integer, search_result.total_results
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.photos.is_a? Array
    assert search_result.photos.any?
    assert search_result.first.is_a? Pexels::Photo

    search_result_with_params = @client.photos.search('test', per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.photos.length, 1
    assert_kind_of Pexels::PhotoSet, search_result_with_params.prev_page
  end

  def test_curated_photos
    search_result = @client.photos.curated

    assert_kind_of Pexels::PhotoSet, search_result
    assert_kind_of Pexels::PhotoSet, search_result.next_page
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.photos.is_a? Array
    assert search_result.photos.any?
    assert search_result.first.is_a? Pexels::Photo

    search_result_with_params = @client.photos.curated(per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.photos.length, 1
    assert_kind_of Pexels::PhotoSet, search_result_with_params.prev_page
  end

  def test_get_photo
    photo = @client.photos[@photo.id]

    assert photo.is_a? Pexels::Photo

    assert_equal photo.id, @photo.id
    assert_equal photo.width, @photo.width
    assert_equal photo.height, @photo.height
    assert_equal photo.url, @photo.url
    assert_equal photo.user.name, @photo.user.name
    assert_equal photo.user.url, @photo.user.url
    assert_equal photo.user.id, @photo.user.id
    assert_equal photo.src, @photo.src
    assert_equal photo.avg_color, @photo.avg_color
    assert_equal photo.alt, @photo.alt

    assert photo.photo?
    assert_equal photo.type, 'Photo'
    refute photo.video?
  end

  def test_invalid_get_photo
    error = assert_raises(Pexels::APIError) do
      @client.photos['this-is-not-a-valid-id']
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

  def test_invalid_color
    error = assert_raises(ArgumentError) do
      @client.photos.search('dog', color: 'foo')
    end
    assert_match '`color` must be one of', error.message
  end

  def test_invalid_color_hex
    error = assert_raises(ArgumentError) do
      @client.photos.search('dog', color: '#gggggg')
    end
    assert_match '`color` must be one of', error.message
  end

  def test_search_filters
    search_result = @client.photos.search('dog', color: '#FF0000', size: :large, orientation: :square)
    assert_kind_of Pexels::PhotoSet, search_result
    assert search_result.photos.any?
  end

  def test_get_photo_open_timeout
    error = assert_raises Pexels::APIError do
      @client.photos[@photo.id, timeout: { open: 0.0000001 }]
    end

    assert_equal 'execution expired', error.message
  end

  def test_get_photo_read_timeout
    error = assert_raises Pexels::APIError do
      @client.photos[@photo.id, timeout: { read: 0.0000001 }]
    end

    assert_equal 'Net::ReadTimeout', error.message
  end

  def test_search_open_timeout
    error = assert_raises Pexels::APIError do
      @client.photos.search('test', timeout: { open: 0.0000001 })
    end

    assert_equal 'execution expired', error.message
  end

  def test_search_read_timeout
    error = assert_raises Pexels::APIError do
      @client.photos.search('test', timeout: { read: 0.0000001 })
    end

    assert_equal 'Net::ReadTimeout', error.message
  end

  def test_curated_open_timeout
    error = assert_raises Pexels::APIError do
      @client.photos.curated(timeout: { open: 0.0000001 })
    end

    assert_equal 'execution expired', error.message
  end

  def test_curated_read_timeout
    error = assert_raises Pexels::APIError do
      @client.photos.curated(timeout: { read: 0.0000001 })
    end

    assert_equal 'Net::ReadTimeout', error.message
  end
end
