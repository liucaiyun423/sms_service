class TextMessageDeliverJob < ApplicationJob
  include HttpStatusCodes
  queue_as :default

  # perform the job, if fails, throws error, so Sidekiq will retry later;
  def perform(id)
    provider = SmsProvider.get_fastest_provider
    raise SmsProvider::NoSmsProviderError unless provider

    msg = start_job(id)
    return unless msg
    Sidekiq.logger.info "Started processing text_message: #{id}"


    message_id, duration = send_request(provider.url, msg)
    Sidekiq.logger.info "request sent for text_message: #{id}"
    provider.add_response_log(id, duration)
    unless message_id
      msg.request_failed!
      raise Sms::Client::SmsProviderOfflineError
    end
    msg.update!(status: :requested, message_id: message_id)
    Sidekiq.logger.info "text_message: #{id} request was accepted by remote SMS provider, message_id:#{message_id}"
  end

  # fetch the job, and mark it as started
  # receives the TextMessage id
  # returns the TextMessage if valid, false otherwise
  def start_job(id)
    msg = TextMessage.find_by!(id: id, status: %i[queued request_failed])
    msg.started!
    msg
  rescue ActiveRecord::RecordNotFound, ActiveRecord::StaleObjectError => e
    Sidekiq.logger.info e.message
    Sidekiq.logger.info e.backtrace.join("\n")
    false
  end

  # send the request to SMS service provider
  # returns the message_id if succeeds, otherwise nil.
  #        and duration for the request-response cycle.
  def send_request(provider_url, msg)
    client = Sms::Client.new(token: ENV['SMS_ACCESS_TOKEN'])
    callback_url = SmsProvider::DEFAULT_CALLBACK_URL
    data = { id: msg.id, message: msg.message, callback_url: callback_url }
    response = client.post(provider_url, data)
    message_id = Oj.load(response.body)&.fetch('message_id')&.strip
    message_id = nil if message_id&.empty? # in case sms service provider returns empty message_id;
    duration = response.status == ENDPOINT_OFFLINE ? Sms::Client::TIMEOUT_IN_MINUTES : response.env[:duration]
    message_id&.empty? ? message_id : nil
    [message_id, duration]
  rescue Net::ReadTimeout
    Sidekiq.logger.error "Request to #{provider_url} for job #{msg.id} timed out."
    duration = Sms::Client::TIMEOUT_IN_MINUTES
    [nil, duration]
  end
end