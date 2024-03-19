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
        @_themes ||= Themes.new(self)
      end

      def connection
        @_connection ||= Faraday.new(url: @base_url) do |faraday|
          faraday.use(Faraday::Response::RaiseError)

          faraday.request(:url_encoded)

          faraday.response(:json, content_type: "application/json")

          faraday.headers["Content-Type"] = "application/json"
          faraday.headers["Authorization"] = "Bearer #{@access_token}"

          faraday.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end
