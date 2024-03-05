require 'byebug'
require 'pg'
require 'rspec'
require 'rack/test'
require_relative '../server'
require_relative '../services/db_service'
require_relative '../services/tests_service'

ENV['RACK_ENV'] = 'test'
ENV['TEST_DB'] = 'relabs_test'

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

  config.before(:each) { DbService.setup_test_db }
  config.after(:each)  { DbService.drop_test_db }
end
