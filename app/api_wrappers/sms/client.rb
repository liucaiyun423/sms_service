module Sms
  class Client
    include HttpStatusCodes

    CONTENT_TYPE_HEADER_NAME = 'Content-Type'.freeze
    JSON_CONTENT = 'application/json'.freeze
    AUTH_HEADER_NAME = 'Authorization'.freeze
    TIMEOUT_IN_SECONDS = 2
    TIMEOUT_IN_MINUTES = TIMEOUT_IN_SECONDS * 60

    SmsProviderOfflineError = Class.new(StandardError)

    attr_reader :access_token

    def initialize(token: nil)
      @access_token = token
    end

    def post(url, data)
      conn = Faraday::Connection.new { |conn| conn.request :timer }
      conn.post(url) do |req|
        req.options.timeout = TIMEOUT_IN_SECONDS
        req.headers[CONTENT_TYPE_HEADER_NAME] = JSON_CONTENT
        req.body = data.to_json
        req.headers[AUTH_HEADER_NAME] = access_token if access_token
      end
    end
  end
end
