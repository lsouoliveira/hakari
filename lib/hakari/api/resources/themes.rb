# frozen_string_literal: true

module Hakari
  module Api
    class Themes < Resource
      def list(**params)
        response = get("themes", params)
        Collection.from_response(response, Theme)
      end

      def create(**params)
        payload = build_payload(**params)

        response = post("themes", payload) do |request|
          request.headers["Content-Type"] = "multipart/form-data"
        end

        Theme.new(response.body)
      end

      def patch(**params)
        payload = deep_compact(build_payload(**params))

        response = patch_request("themes/#{params[:id]}", payload) do |request|
          request.headers["Content-Type"] = "multipart/form-data"
        end

        Theme.new(response.body)
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

      def build_payload(**params)
        payload = {
          theme: {
            name: params[:name],
            description: params[:description],
            version: params[:version],
            file: Faraday::Multipart::FilePart.new(params[:file], "application/zip"),
          },
        }

        if params[:thumbnail]
          payload[:theme][:thumbnail] = Faraday::MultiPart::FilePart.new(
            params[:thumbnail],
            "image/png",
          )
        end

        payload
      end

      def deep_compact(hash)
        hash.each_with_object({}) do |(k, v), memo|
          next if v.nil?

          memo[k] = v.is_a?(Hash) ? deep_compact(v) : v
        end
      end

      def calculate_progress(size, transferred)
        return 1 if (size.nil? || size == 0) && transferred > 0

        transferred.to_f / size
      end
    end
  end
end
