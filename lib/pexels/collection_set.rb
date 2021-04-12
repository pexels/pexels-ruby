module Pexels
  class CollectionSet < PaginatedResponse
    alias_method :collections, :data
    public :collections

    def initialize(response)
      super
      @data = attrs.fetch('collections', []).map { |attrs| Pexels::Collection.new(attrs) }
    end
  end
end
