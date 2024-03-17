# frozen_string_literal: true

module Hakari
  module Api
    class Themes < Resource
      def list
        response = get("themes")
        Collection.from_response(response, Theme)
      end

      def pull(theme_id, progress_proc = nil)
        path = "#{client.base_url}/themes/#{theme_id}"
        headers = {
          "Accept" => "application/zip",
          "Authorization" => "Bearer #{client.access_token}",
        }
        content_length = 0

        Down::NetHttp.download(
          path,
          headers: headers,
          content_length_proc: ->(size) { content_length = size },
          progress_proc: ->(progress) {
            progress_proc&.call(calculate_progress(content_length, progress))
          },
        )
      end

      private

      def calculate_progress(size, transferred)
        return 1 if (size.nil? || size == 0) && transferred > 0

        transferred.to_f / size
      end
    end
  end
end
