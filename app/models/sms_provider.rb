class SmsProvider < ApplicationRecord
  # 1) serves as configuration model for Text Service provider
  # 2) manages the corresponding response time log in Redis
  ROLLING_PERIOD_IN_SECONDS = ENV['SMS_ROLLING_PERIOD_IN_SECONDS'] || 60
  DEFAULT_CALLBACK_URL = ENV['SMS_CALLBACK_URL'] || (Rails.env.development? ? Rails.configuration.sms_callback_url : '')

  NoSmsProviderError = Class.new(StandardError)
  # id: any uniq string to uniquely idenify this request.
  #     in text_message_deliver_job, it is TextMesssage.id in postgres
  # set the expiration time to rolling period,
  # letting redis server handles cleanup of expiring old entries.
  def add_response_log(id, duration)
    key = [redis_key_prefix, Time.now.to_i, id].join('/')
    Redis.new.set(key, duration, ex: ROLLING_PERIOD_IN_SECONDS)
  end

  def calc_provider_rolling_average
    r = Redis.new
    keys = r.keys(redis_key_prefix + '*')
    # when there is no response time entry,
    # give it higher priority, return 0
    return 0 if keys.empty?

    durations = r.mget(keys).map(&:to_f)
    durations.sum / durations.length
  end

  class << self
    # iterate over all providers and calculate each one's average response
    # time over the past rolling period, pick the one with best avg response time.
    # if no existing response time entries in redis, default it to 0;
    #  unreachable provider should have set to Sms::Client::TIMEOUT_IN_SECONDS
    def get_fastest_provider
      min_avg = Float::INFINITY
      provider = nil
      all.each do |curr|
        avg = curr.calc_provider_rolling_average
        provider = curr if avg < min_avg
        min_avg = [avg, min_avg].min
      end
      provider
    end

  end
end