# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Api::Collection) do
  describe "#from_response" do
    it "should return a Collection" do
      data = []
      headers = {
        "X-Total" => 1,
        "X-Page" => 1,
        "X-Total-Count" => 1,
      }
      dummy_response = double(
        "response",
        body: data.to_json,
        headers: headers,
      )

      collection = Hakari::Api::Collection.from_response(dummy_response, Hakari::Api::Object)

      expect(collection).to(be_a(Hakari::Api::Collection))
    end
  end
end
