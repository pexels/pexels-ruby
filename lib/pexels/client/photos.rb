class Pexels::Client::Photos

  def initialize(client)
    @client = client
  end

  def [](id)
    response = @client.request("#{Pexels.api_version}/photos/#{id}")
    Pexels::Photo.new(response)
  end
  alias_method :find, :[]

  def search(query, per_page: 15, page: 1, locale: 'en-US')
    response = @client.request(
      "#{Pexels.api_version}/search",
      params: {
        query: query,
        per_page: per_page,
        page: page,
        locale: locale
      }
    )

    Pexels::PhotoSet.new(response)
  end

  def curated(per_page: 15, page: 1)
    response = @client.request(
      "#{Pexels.api_version}/curated",
      params: {
        per_page: per_page,
        page: page,
      }
    )

    Pexels::PhotoSet.new(response)
  end
end
