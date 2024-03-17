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

  describe "#parse_response" do
    context "when the response is valid JSON" do
      it "should return an OpenStruct" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double("response", body: '{"key": "value"}')

        parsed_response = resource.parse_response(response)

        expect(parsed_response.key).to(eq("value"))
      end
    end

    context "when the response is invalid JSON" do
      it "should raise a JSON::ParserError" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double("response", body: "invalid json")

        expect { resource.parse_response(response) }
          .to(raise_error(JSON::ParserError))
      end
    end
  end

  describe "#parse_collection" do
    context "when the response is valid JSON" do
      it "should return an OpenStruct with :items present" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)
        response = double(
          "response",
          body: '[{"key": "value"}]',
          headers: {},
        )

        parsed_collection = resource.parse_collection(response)

        expect(parsed_collection.items.first.key).to(eq("value"))
      end

      it "should return an OpenStruct with :meta present" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double(
          "response",
          body: '[{"key": "value"}]',
          headers: {
            "X-Total" => "10",
            "X-Page" => "1",
            "X-Total-Count" => "100",
          },
        )

        parsed_collection = resource.parse_collection(response)

        expect(parsed_collection.meta).not_to(be_empty)
      end

      it "should return a OpenStruct that contains the attribute :total_pages" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double(
          "response",
          body: '[{"key": "value"}]',
          headers: {
            "X-Total" => "10",
            "X-Page" => "1",
            "X-Total-Count" => "100",
          },
        )

        parsed_collection = resource.parse_collection(response)

        expect(parsed_collection.meta[:total_pages]).to(eq(10))
      end

      it "should return a OpenStruct that contains the attribute :current_page" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double(
          "response",
          body: '[{"key": "value"}]',
          headers: {
            "X-Total" => "10",
            "X-Page" => "1",
            "X-Total-Count" => "100",
          },
        )

        parsed_collection = resource.parse_collection(response)

        expect(parsed_collection.meta[:current_page]).to(eq(1))
      end

      it "should return a OpenStruct that contains the attribute :total_count" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double(
          "response",
          body: '[{"key": "value"}]',
          headers: {
            "X-Total" => "10",
            "X-Page" => "1",
            "X-Total-Count" => "100",
          },
        )

        parsed_collection = resource.parse_collection(response)

        expect(parsed_collection.meta[:total_count]).to(eq(100))
      end
    end

    context "when the response is invalid JSON" do
      it "should raise a JSON::ParserError" do
        client = Hakari::Api::Client.new(
          base_url: "http://example.com",
          access_token: "123",
        )

        resource = Hakari::Api::Resource.new(client)

        response = double("response", body: "invalid json")

        expect { resource.parse_collection(response) }
          .to(raise_error(JSON::ParserError))
      end
    end
  end
end
