# frozen_string_literal: true

module Hakari
  module Api
    class Resource
      def initialize(client)
        @client = client
      end

      def perform_request(method, path, options = {})
        @client.connection.send(method, path, options)
      rescue Faraday::Error => e
        raise Hakari::RequestError, e
      end

      def get(path, options = {})
        perform_request(:get, path, options)
      end

      def parse_response(response)
        json = JSON.parse(response.body, symbolize_names: true)
        OpenStruct.new(json)
      end

      def parse_collection(response)
        json = JSON.parse(response.body, symbolize_names: true)
        OpenStruct.new(
          items: json.map(&OpenStruct.method(:new)),
          meta: {
            total_pages: response.headers["X-Total"].to_i,
            current_page: response.headers["X-Page"].to_i,
            total_count: response.headers["X-Total-Count"].to_i,
          },
        )
      end
    end
  end
end
