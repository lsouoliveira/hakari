# frozen_string_literal: true

module Hakari
  module Api
    class Resource
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def perform_request(method, path, options = {}, &block)
        @client.connection.send(method, path, options, &block)
      rescue Faraday::Error => e
        raise Hakari::RequestError, e
      end

      def get(path, options = {}, &block)
        perform_request(:get, path, options, &block)
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
