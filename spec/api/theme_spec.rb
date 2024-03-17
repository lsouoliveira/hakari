# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Api::Theme) do
  describe "#list" do
    it "should return a list of themes with 2 items" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )
      theme = Hakari::Api::Theme.new(client)
      dummy_response = [
        build_theme(name: "theme1"),
        build_theme(name: "theme2"),
      ]

      puts dummy_response.to_json

      stub_request(:get, "http://example.com/themes")
        .to_return(status: 200, body: dummy_response.to_json)

      response = theme.list

      expect(response.items.length).to(eq(2))
    end
  end

  describe "#pull" do
    it "should return a Tempfile" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )

      theme = Hakari::Api::Theme.new(client)

      stub_request(:get, "http://example.com/themes/123")
        .to_return(status: 200, body: File.read("spec/fixtures/theme.zip"))

      response = theme.pull("123")

      expect(response).to(be_a(Tempfile))
    end
  end

  def build_theme(**opts)
    {
      id: opts[:id] || Faker::Number.number(digits: 10),
      name: opts[:name] || Faker::Name.name,
      version: opts[:version] || Faker::App.version,
    }
  end
end
