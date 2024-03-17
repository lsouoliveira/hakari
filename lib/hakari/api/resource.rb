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
    end
  end
end
