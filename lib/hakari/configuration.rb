# frozen_string_literal: true

module Hakari
  class Configuration
    attr_accessor :client_id, :redirect_uri, :authorization_url, :oauth_provider_url

    def initialize(**opts)
      @client_id = opts[:client_id]
      @redirect_uri = opts[:redirect_uri]
      @authorization_url = opts[:authorization_url]
      @oauth_provider_url = opts[:oauth_provider_url]
    end
  end
end
