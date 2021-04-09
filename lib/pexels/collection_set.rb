module Pexels
  class CollectionSet < PaginatedResponse
    alias_method :collections, :data
    public :collections

    def initialize(attrs)
      super
      @data = attrs.fetch('collections', []).map { |attrs| Pexels::Collection.new(attrs) }
    end
  end
end
