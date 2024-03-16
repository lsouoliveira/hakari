# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe(Hakari::Core::Commands::Login) do
  describe "#run" do
    it "should set Hakari.access_token" do
      login_command = Hakari::Core::Commands::Login.new

      token_info = double(
        "token_info",
        access_token: Faker::Internet.uuid,
      )

      user_info = double(
        "user_info",
        uid: Faker::Number.number(digits: 10),
      )

      temp_file = Tempfile.new
      storage = Hakari::Storage.new(temp_file.path)

      Hakari.storage = storage

      allow(login_command).to(receive(:wait_for_keypress))
      allow(Launchy).to(receive(:open))
      allow(login_command).to(receive(:request_authorization_code).and_return({ "code" => "123" }))
      allow_any_instance_of(Hakari::Authorization::Client)
        .to(receive(:exchange_code_for_token)
        .and_return(token_info))
      allow_any_instance_of(Hakari::Authorization::Client)
        .to(receive(:user_info)
        .and_return(user_info))

      login_command.run

      expect(Hakari.access_token).to(eq(token_info.access_token))
    end

    it "should store the uid and access_token in the storage" do
      login_command = Hakari::Core::Commands::Login.new

      token_info = double(
        "token_info",
        access_token: Faker::Internet.uuid,
      )

      user_info = double(
        "user_info",
        uid: Faker::Number.number(digits: 10),
      )

      temp_file = Tempfile.new
      storage = Hakari::Storage.new(temp_file.path)

      Hakari.storage = storage

      allow(login_command).to(receive(:wait_for_keypress))
      allow(Launchy).to(receive(:open))
      allow(login_command).to(receive(:request_authorization_code).and_return({ "code" => "123" }))
      allow_any_instance_of(Hakari::Authorization::Client)
        .to(receive(:exchange_code_for_token)
        .and_return(token_info))
      allow_any_instance_of(Hakari::Authorization::Client)
        .to(receive(:user_info)
        .and_return(user_info))

      login_command.run
      credentials = storage.retrieve("credentials")

      expect(credentials).to(eq({ "uid" => user_info.uid, "access_token" => token_info.access_token }))
    end
  end
end
