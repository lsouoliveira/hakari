module Hakari
  module Api
    class Collection
      attr_reader :items, :total_pages, :current_page, :total_count

      def initialize(items:, total_pages:, current_page:, total_count:)
        @items = items
        @total_pages = total_pages
        @current_page = current_page
        @total_count = total_count
      end

      def self.from_response(response, object_class)
        json = JSON.parse(response.body, symbolize_names: true)
        Collection.new(
          items: json.map(&object_class.method(:new)),
            total_pages: response.headers["X-Total"].to_i,
            current_page: response.headers["X-Page"].to_i,
            total_count: response.headers["X-Total-Count"].to_i
        )
      end
    end
  end
end
