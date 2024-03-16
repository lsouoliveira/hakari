# frozen_string_literal: true

require "colorize"
require "launchy"
require "cgi"
require "socket"
require "thor"
require "securerandom"

require_relative "hakari/version"
require_relative "hakari/error"
require_relative "hakari/command"
require_relative "hakari/cli"
require_relative "hakari/configuration"
require_relative "hakari/logging"
require_relative "hakari/storage"
require "hakari/authorization/server"
require "hakari/authorization/client"

module Hakari
  class << self
    def access_token
      @_access_token
    end

    def access_token=(token)
      @_access_token = token
    end

    def configuration
      @_configuration ||= Configuration.new(
        client_id: ENV["HAKARI_CLIENT_ID"],
        redirect_uri: ENV["HAKARI_REDIRECT_URI"],
        authorization_url: ENV["HAKARI_AUTHORIZATION_URL"],
        oauth_provider_url: ENV["HAKARI_OAUTH_PROVIDER_URL"],
      )
    end

    def configure
      yield configuration
    end

    def storage
      @_storage ||= Storage.new
    end

    def storage=(storage)
      @_storage = storage
    end
  end
end
