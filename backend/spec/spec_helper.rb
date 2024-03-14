require 'byebug'
require 'json'
require 'pg'
require 'rspec'
require 'rack/test'
require_relative '../lib/custom_errors'
require_relative '../server'
require_relative '../services/db_service'
require_relative '../services/tests_service'
require_relative '../services/connection_service'
require_relative '../models/test_type'
require_relative '../models/test'
require_relative '../models/patient'
require_relative '../models/doctor'
require_relative '../jobs/import_job'

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

  config.before(:each) do |test|
    DbService.setup_test_db unless test.metadata[:skip_before]
  end
  config.after(:each) do |test|
    DbService.cleanup_test_db unless test.metadata[:skip_after]
  end
end
