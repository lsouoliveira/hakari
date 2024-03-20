# frozen_string_literal: true

ENV["HAKARI_ENV"] = "test"

require "hakari"
require "webmock/rspec"
require "faker"
require "support/api_helper"

# Prevent the tests from making HTTP requests to external services
WebMock.disable_net_connect!(allow_localhost: false)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.include(ApiHelper)

  # Clear the storage before each test
  config.before do
    Hakari.storage.clear
  end
end
