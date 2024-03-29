# frozen_string_literal: true

require "dotenv"
require "down"
require "zip"
require "tty-progressbar"
require "tty-prompt"
require "tty-link"
require "tty-box"
require "faraday"
require "faraday/multipart"
require "colorize"
require "launchy"
require "cgi"
require "socket"
require "thor"
require "securerandom"
require "pastel"
require "listen"

require_relative "hakari/version"
require_relative "hakari/error"
require_relative "hakari/command"
require_relative "hakari/cli"
require_relative "hakari/configuration"
require_relative "hakari/logging"
require_relative "hakari/storage"
require_relative "hakari/authorization/server"
require_relative "hakari/authorization/client"
require_relative "hakari/api/client"
require_relative "hakari/api/resource"
require_relative "hakari/api/collection"
require_relative "hakari/api/object"
require_relative "hakari/api/resources/themes"
require_relative "hakari/api/objects/theme"
require_relative "hakari/themes/theme_extractor"
require_relative "hakari/themes/watcher"
require_relative "hakari/themes/syncer"
require_relative "hakari/themes/packer"

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
        api_base_url: ENV["HAKARI_API_BASE_URL"],
      )
    end

    def configure
      yield configuration
    end

    def storage
      @_storage ||= Storage.new(
        test? ? Tempfile.new("hakari").path : File.join(Dir.home, ".hakari.json"),
      )
    end

    def storage=(storage)
      @_storage = storage
    end

    def api_client
      Hakari::Api::Client.new(
        base_url: Hakari.configuration.api_base_url,
        access_token: Hakari.access_token,
      )
    end

    def init
      raise Hakari::Error, "Hakari client_id is required" if configuration.client_id.nil?
      raise Hakari::Error, "Hakari redirect_uri is required" if configuration.redirect_uri.nil?
      raise Hakari::Error, "Hakari authorization_url is required" if configuration.authorization_url.nil?
      raise Hakari::Error, "Hakari oauth_provider_url is required" if configuration.oauth_provider_url.nil?
      raise Hakari::Error, "Hakari api_base_url is required" if configuration.api_base_url.nil?

      credentials = storage.retrieve("credentials")
      Hakari.access_token = credentials["access_token"] if credentials
    end

    def test?
      ENV["HAKARI_ENV"] == "test"
    end

    def load_environment
      Dotenv.load(".env", ".env.#{ENV["HAKARI_ENV"]}", ".env.#{ENV["HAKARI_ENV"]}.local")
    end
  end
end

Hakari.load_environment
Hakari.init
