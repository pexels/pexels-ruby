class Pexels::Client::Photos

  def initialize(client)
    @client = client
  end

  def [](id)
    response = @client.request("/v1/photos/#{id}")
    Pexels::Photo.new(response)
  end

  def search(query, per_page: 15, page: 1, locale: 'en-US')
    response = @client.request(
      '/v1/search',
      params: {
        query: query,
        per_page: per_page,
        page: page,
        locale: locale
      }
    )

    Pexels::Response.new(response)
  end

  def curated(per_page: 15, page: 1)
    response = @client.request(
      '/v1/curated',
      params: {
        per_page: per_page,
        page: page,
      }
    )

    Pexels::Response.new(response)
  end
end
