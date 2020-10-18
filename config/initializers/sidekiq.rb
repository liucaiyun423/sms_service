Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_SERVER'] || 'redis://localhost:6379' }
end
require 'sidekiq/api'

