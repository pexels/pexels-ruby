module Pexels
  class PaginatedResponse
    include Enumerable

    attr_reader :total_results,
      :page,
      :per_page,
      :next_page,
      :data

    private :data

    def initialize(response)
      @response = response
      @attrs = @response.body

      @total_results = attrs.fetch('total_results', nil)
      @page = attrs.fetch('page')
      @per_page = attrs.fetch('per_page')
      @next_page = attrs.fetch('next_page', nil)
    end

    def each(&block)
      if block_given?
        data.each(&block)
      else
        to_enum(:each)
      end
    end
  end
end
