# frozen_string_literal: true

module Hakari
  module Api
    class Theme < Resource
      def list
        response = get("themes")
        parse_collection(response)
      end
    end
  end
end
