require 'minitest/autorun'
require 'pexels'

class TestPhoto < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @photo = @client.photos.search('test', per_page: 1).photos.first
  end

  def test_successful_searches
    search_result = @client.photos.search('test')

    assert search_result.is_a? Pexels::Response
    assert search_result.next_page.is_a? String
    assert search_result.total_results.is_a? Integer
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.photos.is_a? Array
    assert search_result.photos.any?
    assert search_result.photos.first.is_a? Pexels::Photo

    search_result_with_params = @client.photos.search('test', per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.photos.length, 1
  end

  def test_curated_photos
    search_result = @client.photos.curated

    assert search_result.is_a? Pexels::Response
    assert search_result.next_page.is_a? String
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.photos.is_a? Array
    assert search_result.photos.any?
    assert search_result.photos.first.is_a? Pexels::Photo

    search_result_with_params = @client.photos.curated(per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.photos.length, 1
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
  end

  def test_invalid_get_photo
    photo = @client.photos['this-is-not-a-valid-id']
    raise 'This should not happen'
    rescue StandardError => exception
      assert exception.is_a? Pexels::APIError
      assert_equal exception.message, 'Not Found'
  end
end
