# frozen_string_literal: true

module Hakari
  module Authorization
    class Server
      SERVER_PORT = 9480

      # Starts a server that listens for incoming requests and returns the
      # query parameters as a hash.
      #
      # @return [Hash] the query parameters
      def start
        server = TCPServer.new(SERVER_PORT)

        loop do
          connection = server.accept
          request = connection.gets

          connection.puts "You can close this window now."
          connection.close

          return handle_request(request)
        end
      end

      private

      def handle_request(request)
        _, path = request.split(" ")
        uri = URI.parse(path)
        cgi_params = CGI.parse(uri.query)

        flatten_params(cgi_params)
      end

      def flatten_params(params)
        params.each_with_object({}) do |(key, value), hash|
          hash[key] = if value.is_a?(Array) && value.size == 1
            value.first
          else
            value
          end
        end
      end
    end
  end
end
