# SimpleCov require for coverage metric
require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
end
# For API testing
require 'rack/test'

# Set the rack environment for testing
ENV['RACK_ENV'] ||= 'test'

# Require application.rb, which requires everything else
require File.expand_path('../../config/application', __FILE__)

# Standard RSpec config
RSpec.configure do |config|
  config.color = true
  
  # uncomment below if you're not into the whole brevity thing
  # config.formatter = :documentation

  config.expect_with :rspec
  config.mock_with :rspec

end

require 'capybara/rspec'
Capybara.configure do |config|
  config.app = ReverbRecords::App.new
  config.server_port = 9293
end
