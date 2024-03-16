# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Authorization::Client) do
  describe "#exchange_code_for_token" do
    context "when the request is successful" do
      it "should return a OpenStruct with :access_token present" do
        client = Hakari::Authorization::Client.new(
          base_url: "http://localhost:3000",
          client_id: "client_id",
          redirect_uri: "http://localhost:3000/auth/callback",
        )

        response = {
          access_token: Faker::Alphanumeric.alphanumeric(number: 20),
        }

        stub_request(:post, "http://localhost:3000/oauth/token")
          .and_return(status: 200, body: response.to_json)

        token_info = client.exchange_code_for_token("authorization_code")

        expect(token_info.access_token).to(eq(response[:access_token]))
      end
    end

    context "when the request is not successful" do
      it "should raise Hakari::FailedToExchangeAuthorizationCodeError" do
        client = Hakari::Authorization::Client.new(
          base_url: "http://localhost:3000",
          client_id: "client_id",
          redirect_uri: "http://localhost:3000/auth/callback",
        )

        stub_request(:post, "http://localhost:3000/oauth/token")
          .and_return(status: 500)

        expect do
          client.exchange_code_for_token("authorization_code")
        end.to(raise_error(Hakari::FailedToExchangeAuthorizationCodeError))
      end
    end
  end

  describe "#user_info" do
    context "when the request is successful" do
      it "should return a OpenStruct with :uid present" do
        client = Hakari::Authorization::Client.new(
          base_url: "http://localhost:3000",
          client_id: "client_id",
          redirect_uri: "http://localhost:3000/auth/callback",
        )

        response = {
          uid: Faker::Alphanumeric.alphanumeric(number: 20),
        }

        stub_request(:get, "http://localhost:3000/oauth/token/info")
          .and_return(status: 200, body: response.to_json)

        user_info = client.user_info("access_token")

        expect(user_info.uid).to(eq(response[:uid]))
      end
    end

    context "when the request is not successful" do
      it "should raise Hakari::FailedToRetrieveUserTokenInfoError" do
        client = Hakari::Authorization::Client.new(
          base_url: "http://localhost:3000",
          client_id: "client_id",
          redirect_uri: "http://localhost:3000/auth/callback",
        )

        stub_request(:get, "http://localhost:3000/oauth/token/info")
          .and_return(status: 500)

        expect do
          client.user_info("access_token")
        end.to(raise_error(Hakari::FailedToRetrieveUserTokenInfoError))
      end
    end
  end
end
