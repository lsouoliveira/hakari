# frozen_string_literal: true

require "net/http"
require "json"

module Hakari
  module Authorization
    class Client
      def initialize(base_url:, client_id:, redirect_uri:)
        @base_url = base_url
        @client_id = client_id
        @redirect_uri = redirect_uri
      end

      # Exchange an authorization code for an access token.
      # @param [String] code
      # @raise [FailedToExchangeAuthorizationCodeError] if the request fails
      # @return [OpenStruct] the token info.
      def exchange_code_for_token(code)
        request = Net::HTTP.post_form(
          request_url("oauth/token"),
          {
            client_id: @client_id,
            code: code,
            grant_type: "authorization_code",
            redirect_uri: @redirect_uri,
            content_type: "application/json",
          },
        )

        raise FailedToExchangeAuthorizationCodeError, request.body unless request.code == "200"

        parse_response(request)
      end

      # Retrieve user info from the OAuth provider.
      # @param [String] access_token
      # @raise [FailedToRetrieveUserTokenInfoError] if the request fails
      # @return [OpenStruct] the user info.
      def user_info(access_token)
        request = Net::HTTP.get_response(
          request_url("oauth/token/info"),
          {
            authorization: "Bearer #{access_token}",
            content_type: "application/json",
          },
        )

        raise FailedToRetrieveUserTokenInfoError, request.body unless request.code == "200"

        parse_response(request)
      end

      private

      def parse_response(response)
        OpenStruct.new(JSON.parse(response.body))
      end

      def request_url(path)
        URI("#{@base_url}/#{path}")
      end
    end
  end
end
