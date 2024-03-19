# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Api::Resource) do
  describe "#perform_request" do
    context "when the request is successful" do
      it "should return the response" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )
        resource = Hakari::Api::Resource.new(client)
        dummy_response = double("response", body: "{}")

        allow(client.connection).to(receive(:get).and_return(dummy_response))

        response = resource.perform_request(:get, "/path")

        expect(response).to(eq(dummy_response))
      end
    end

    context "when the request fails" do
      it "should raise a RequestError" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        allow(client.connection).to(receive(:get).and_raise(Faraday::Error))

        expect { resource.perform_request(:get, "/path") }
          .to(raise_error(Hakari::RequestError))
      end
    end
  end

  describe "#get" do
    it "should perform a GET request" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )
      resource = Hakari::Api::Resource.new(client)

      dummy_response = double("response", body: "{}")

      allow(resource).to(receive(:perform_request).and_return(dummy_response))

      response = resource.get("/path")

      expect(response).to(eq(dummy_response))
    end
  end

  describe "#post" do
    it "should perform a POST request" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )
      resource = Hakari::Api::Resource.new(client)

      dummy_response = double("response", body: "{}")

      allow(resource).to(receive(:perform_request).and_return(dummy_response))

      response = resource.post("/path")

      expect(response).to(eq(dummy_response))
    end
  end

  describe "#patch_request" do
    it "should perform a PATCH request" do
      client = Hakari::Api::Client.new(
        base_url: "http://example.com",
        access_token: "123",
      )
      resource = Hakari::Api::Resource.new(client)

      dummy_response = double("response", body: "{}")

      allow(resource).to(receive(:perform_request).and_return(dummy_response))

      response = resource.patch_request("/path")

      expect(response).to(eq(dummy_response))
    end
  end
end
