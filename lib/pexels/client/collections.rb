class Pexels::Client::Collections
  def initialize(client)
    @client = client
  end

  def all(per_page: 15, page: 1, timeout: { open: nil, read: nil })
    response = @client.request(
      "#{Pexels.api_version}/collections",
      params: {
        per_page: per_page,
        page: page
      },
      options: {
        open_timeout: timeout[:open],
        read_timeout: timeout[:read]
      })

    Pexels::CollectionSet.new(response)
  end

  def featured(per_page: 15, page: 1, timeout: { open: nil, read: nil })
    response = @client.request(
      "#{Pexels.api_version}/collections/featured",
      params: {
        per_page: per_page,
        page: page
      },
      options: {
        open_timeout: timeout[:open],
        read_timeout: timeout[:read]
      })

    Pexels::CollectionSet.new(response)
  end

  def [](id, type: nil, per_page: 15, page: 1, timeout: { open: nil, read: nil })
    response = @client.request(
      "#{Pexels.api_version}/collections/#{id}",
      params: {
        per_page: per_page,
        page: page,
        type: type
      },
      options: {
        open_timeout: timeout[:open],
        read_timeout: timeout[:read]
      })

    Pexels::CollectionMediaSet.new(response)
  end
  alias_method :find, :[]
end
