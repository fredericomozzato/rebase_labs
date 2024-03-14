require 'byebug'
require 'capybara'
require 'capybara/rspec'
require 'rack/test'
require 'selenium/webdriver'
require_relative '../app'
require_relative '../services/api_service'

ENV['RACK_ENV'] = 'test'

def app
  App
end

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument '--headless'
  options.add_argument '--no-sandbox'

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.app = app
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
Capybara.server = :puma, {Silent: true}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    Capybara.server_port = 3001
    ENV['PORT'] = Capybara.server_port.to_s
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each, type: :system) do
  end
end
