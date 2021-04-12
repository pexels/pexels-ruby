require 'cgi'

module Pexels
  class PaginatedResponse
    include Enumerable

    attr_reader :total_results,
      :page,
      :per_page,
      :data

    private :data

    def initialize(response)
      @response = response
      @attrs = @response.body

      @total_results = attrs.fetch('total_results', nil)
      @page = attrs.fetch('page')
      @per_page = attrs.fetch('per_page')
      @prev_page = attrs.fetch('prev_page', nil)
      @next_page = attrs.fetch('next_page', nil)
    end

    def total_pages
      total_results.fdiv(per_page).ceil
    end

    def each(&block)
      if block_given?
        data.each(&block)
      else
        to_enum(:each)
      end
    end

    def next_page
      return unless @next_page

      request.params[:page] = extract_page(@next_page)
      self.class.new(request.call)
    end

    def prev_page
      return unless @prev_page

      request.params[:page] = extract_page(@next_page)
      self.class.new(request.call)
    end

    private

    attr_reader :response, :attrs

    def request
      response.request
    end

    def extract_page(url)
      CGI.parse(URI.parse(url).query)['page'].first
    end
  end
end
