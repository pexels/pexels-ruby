class Pexels::Client::Videos

  def initialize(client)
    @client = client
  end

  def [](id)
    response = @client.request("/videos/videos/#{id}")
    Pexels::Video.new(response)
  end

  def search(query, per_page: 15, page: 1)
    response = @client.request(
      '/videos/search',
      params: {
        query: query,
        per_page: per_page,
        page: page,
      }
    )

    Pexels::Response.new(response)
  end

  def popular(per_page: 15, page: 1)
    response = @client.request(
      '/videos/popular',
      params: {
        per_page: per_page,
        page: page,
      }
    )

    Pexels::Response.new(response)
  end
end
