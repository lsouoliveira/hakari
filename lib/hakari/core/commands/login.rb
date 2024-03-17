# frozen_string_literal: true

module Hakari
  module Core
    module Commands
      class Login < Hakari::Command
        def run
          wait_for_keypress
          authenticate

          puts "You are now #{"logged".colorize(:green)} in!"
        end

        private

        def wait_for_keypress
          puts "Press enter to open the browser to login or press #{"Ctrl+C".colorize(:yellow)} to cancel"
          $stdin.gets
        end

        def authenticate
          authorization_params = request_authorization_code
          token_info = client.exchange_code_for_token(authorization_params["code"])
          user_info = client.user_info(token_info.access_token)

          save_credentials(token_info, user_info)

          Hakari.access_token = token_info.access_token
        end

        def request_authorization_code
          params = {
            client_id: Hakari.configuration.client_id,
            redirect_uri: Hakari.configuration.redirect_uri,
            response_type: "code",
          }
          request_url = "#{Hakari.configuration.authorization_url}?#{URI.encode_www_form(params)}"
          server = Thread.new { Hakari::Authorization::Server.new.start }
          Launchy.open(request_url) do
            puts "Please go to the following URL and login: #{Hakari.configuration.authorization_url}"
          end
          server.join
          server.value
        end

        def save_credentials(token_info, user_info)
          credentials = {
            uid: user_info.uid,
            access_token: token_info.access_token,
          }

          Hakari.storage.store(
            "credentials",
            credentials,
          )
        end

        def client
          @_client ||= Hakari::Authorization::Client.new(
            base_url: Hakari.configuration.oauth_provider_url,
            client_id: Hakari.configuration.client_id,
            redirect_uri: Hakari.configuration.redirect_uri,
          )
        end
      end
    end
  end
end
