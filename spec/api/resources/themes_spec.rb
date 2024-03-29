# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Api::Theme) do
  describe "#list" do
    it "should return a list of themes with 4 items" do
      themes = Hakari::Api::Themes.new(api_client)

      stub_api_request(:get, "themes", stub_response("themes/list.json"))

      expect(themes.list.items.size).to(eq(4))
    end
  end

  describe "#create" do
    it "should return a theme" do
      themes = Hakari::Api::Themes.new(api_client)
      payload = {
        name: Faker::Name.name,
        description: Faker::Lorem.sentence,
        version: Faker::App.version,
        file: File.open("spec/fixtures/theme.zip"),
        thumbnail: File.open("spec/fixtures/640x480.jpg"),
        demo: File.open("spec/fixtures/1920x1080.jpg"),
        mobile_demo: File.open("spec/fixtures/320x240.jpg"),
      }

      stub_api_request(:post, "themes", stub_response("themes/create.json"))

      response = themes.create(**payload)

      expect(response).to(be_a(Hakari::Api::Theme))
    end
  end

  describe "#patch" do
    it "should return a theme" do
      themes = Hakari::Api::Themes.new(api_client)
      payload = {
        id: Faker::Number.number(digits: 10),
        name: Faker::Name.name,
        description: Faker::Lorem.sentence,
        version: Faker::App.version,
        file: File.open("spec/fixtures/theme.zip"),
      }

      stub_api_request(:patch, "themes/#{payload[:id]}", stub_response("themes/create.json"))

      response = themes.patch(**payload)

      expect(response).to(be_a(Hakari::Api::Theme))
    end
  end

  describe "#pull" do
    it "should return a Tempfile" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )

      theme = Hakari::Api::Themes.new(client)

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
