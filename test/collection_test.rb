require 'minitest/autorun'
require 'pexels'

class TestCollections < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @collection = @client.collections.all(per_page: 1).first
  end

  def test_all
    search_result = @client.collections.all

    assert search_result.is_a? Pexels::CollectionSet
    assert_equal search_result.per_page, 15
    assert_equal search_result.page, 1

    assert search_result.collections.is_a? Array
    assert search_result.collections.any?
    assert search_result.first.is_a? Pexels::Collection

    search_result_with_params = @client.collections.all(per_page: 1, page: 2)
    assert_equal search_result_with_params.per_page, 1
    assert_equal search_result_with_params.page, 2
    assert_equal search_result_with_params.collections.length, 1
  end

  def test_get_collection_media
    collection = @client.collections[@collection.id]
    assert collection.is_a? Pexels::CollectionMediaSet
    assert_equal collection.id, @collection.id

    assert collection.media.is_a? Array
    assert collection.media.any?

    assert_includes([Pexels::Photo, Pexels::Video], collection.media.first.class)

    refute_includes([Pexels::Video], collection.photos.map(&:class))
    refute_includes([Pexels::Photo], collection.videos.map(&:class))
  end

  def test_get_collection_photos
    collection = @client.collections[@collection.id, type: 'photos']
    assert collection.is_a? Pexels::CollectionMediaSet
    assert collection.media.is_a? Array
    assert collection.media.all? { |m| m.is_a?(Pexels::Photo) }
  end

  def test_get_collection_videos
    collection = @client.collections[@collection.id, type: 'videos']
    assert collection.is_a? Pexels::CollectionMediaSet
    assert collection.media.is_a? Array
    assert collection.media.all? { |m| m.is_a?(Pexels::Video) }
  end

  def test_get_collection_invalid_type
    collection = @client.collections[@collection.id, type: 'foo']
    assert collection.is_a? Pexels::CollectionMediaSet
    assert collection.media.is_a? Array
    assert collection.any?
  end

  def test_get_collection_pagination
    collection = @client.collections[@collection.id, per_page: 1, page: 1]
    assert collection.is_a? Pexels::CollectionMediaSet
    assert collection.media.is_a? Array
    assert collection.media.any?

    assert_equal collection.per_page, 1
    assert_equal collection.page, 1
    assert_equal collection.media.length, 1
  end

  def test_invalid_get_collection
    @client.collections['this-is-not-a-valid-id']
    raise 'This should not happen'
  rescue StandardError => exception
    assert exception.is_a? Pexels::APIError
    assert_equal exception.message, 'Not Found'
  end
end
