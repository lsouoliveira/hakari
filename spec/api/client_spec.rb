# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Api::Client) do
  describe "#connection" do
    it "should return a Faraday connection" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )

      expect(client.connection).to(be_a(Faraday::Connection))
    end
  end

  describe "#themes" do
    it "should return a Theme instance" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )

      expect(client.themes).to(be_a(Hakari::Api::Theme))
    end
  end
end
