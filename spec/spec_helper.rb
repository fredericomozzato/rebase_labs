# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

ENV['RACK_ENV'] ='test'

require 'rack/test'
require_relative '../server'

def app
  Server
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Rack::Test::Methods

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
