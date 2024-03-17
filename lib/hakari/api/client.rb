# frozen_string_literal: true

module Hakari
  module Api
    class Client
      attr_reader :base_url, :access_token

      def initialize(base_url:, access_token:)
        @base_url = base_url
        @access_token = access_token

        raise Hakari::Error, "API base url is required" if @base_url.nil?
      end

      def themes
        @_themes ||= Theme.new(self)
      end

      def connection
        @_connection ||= Faraday.new(url: @base_url) do |faraday|
          faraday.request(:url_encoded)
          faraday.adapter(Faraday.default_adapter)
          faraday.use(Faraday::Response::RaiseError)
          faraday.headers["Content-Type"] = "application/json"
          faraday.headers["Authorization"] = "Bearer #{@access_token}"
        end
      end
    end
  end
end
