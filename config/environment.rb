# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.configure do
  config.autoload_paths << "#{Rails.root}/app/api_wrappers"
  config.autoload_paths << "#{Rails.root}/app/services"
end
Rails.application.initialize!
