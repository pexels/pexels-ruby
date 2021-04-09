class Pexels::Client::Collections
  def initialize(client)
    @client = client
  end

  def all(per_page: 15, page: 1)
    response = @client.request(
      '/collections',
      params: {
        per_page: per_page,
        page: page
      })

    Pexels::CollectionSet.new(response)
  end

  def [](id, type: nil, per_page: 15, page: 1)
    response = @client.request(
      "/collections/#{id}",
      params: {
        per_page: per_page,
        page: page,
        type: type
      })

    Pexels::CollectionMediaSet.new(response)
  end
  alias_method :find, :[]
end
