# frozen_string_literal: true

module ApiHelper
  BASE_URL = "http://localhost:3000/v1"

  def api_client
    Hakari::Api::Client.new(
      base_url: BASE_URL,
      access_token: "123",
    )
  end

  def stub_response(
    fixture_path,
    status: 200,
    headers: { "Content-Type" => "application/json" }
  )
    {
      status: status,
      body: File.read("spec/fixtures/#{fixture_path}"),
      headers: headers,
    }
  end

  def stub_api_request(
    method,
    path,
    stub_response
  )
    stub_request(method, "#{BASE_URL}/#{path}")
      .to_return(**stub_response)
  end
end
