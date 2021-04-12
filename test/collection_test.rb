require 'minitest/autorun'
require 'pexels'

class TestCollections < Minitest::Test

  def setup
    @client = Pexels::Client.new(ENV.fetch('PEXELS_API_KEY'))
    @collection = @client.collections.all(per_page: 1).first
  end

  def test_all
    collection = @client.collections.all

    assert_kind_of Pexels::CollectionSet, collection
    assert_equal collection.per_page, 15
    assert_equal collection.page, 1

    assert collection.collections.is_a? Array
    assert collection.collections.any?
    assert collection.first.is_a? Pexels::Collection

    collection_with_params = @client.collections.all(per_page: 1, page: 2)
    assert_equal collection_with_params.per_page, 1
    assert_equal collection_with_params.page, 2
    assert_equal collection_with_params.collections.length, 1
    assert_kind_of Pexels::CollectionSet, collection_with_params.next_page
    assert_kind_of Pexels::CollectionSet, collection_with_params.prev_page
  end

  def test_get_collection_media
    collection = @client.collections[@collection.id]
    assert_kind_of Pexels::CollectionMediaSet, collection
    assert_equal collection.id, @collection.id

    assert_kind_of Array, collection.media
    assert collection.media.any?

    assert_includes([Pexels::Photo, Pexels::Video], collection.media.first.class)

    refute_includes([Pexels::Video], collection.photos.map(&:class))
    refute_includes([Pexels::Photo], collection.videos.map(&:class))
  end

  def test_get_collection_photos
    collection = @client.collections[@collection.id, type: 'photos']
    assert_kind_of Pexels::CollectionMediaSet, collection
    assert_kind_of Array, collection.media
    assert collection.media.all? { |m| m.is_a?(Pexels::Photo) }
  end

  def test_get_collection_videos
    collection = @client.collections[@collection.id, type: 'videos']
    assert_kind_of Pexels::CollectionMediaSet, collection
    assert_kind_of Array, collection.media
    assert collection.media.all? { |m| m.is_a?(Pexels::Video) }
  end

  def test_get_collection_invalid_type
    collection = @client.collections[@collection.id, type: 'foo']
    assert_kind_of Pexels::CollectionMediaSet, collection
    assert_kind_of Array, collection.media
    assert collection.any?
  end

  def test_get_collection_pagination
    collection = @client.collections[@collection.id, per_page: 1, page: 1]
    assert_kind_of Pexels::CollectionMediaSet, collection
    assert_kind_of Array, collection.media
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
