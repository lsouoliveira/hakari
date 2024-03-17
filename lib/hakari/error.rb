# frozen_string_literal: true

module Hakari
  class Error < StandardError; end
  class MissingAuthorizationCodeError < Error; end
  class FailedToExchangeAuthorizationCodeError < Error; end
  class FailedToRetrieveUserTokenInfoError < Error; end

  class RequestError < Error; end
end
