if ENV['CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'vendor'
  end

  if ENV['CI']
    require 'simplecov-cobertura'

    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CoberturaFormatter
    ])
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'rspec/json_expectations'
require 'webmock/rspec'
require 'pundit/rspec'
require 'vcr_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('lib/generators/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# WebMock.disable_net_connect!(:allow_localhost => true, :allow => /insee/)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  config.use_transactional_fixtures = false

  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.include(SelfHostedDoc, :self_hosted_doc)
  config.default_formatter = config.files_to_run.one? ? 'doc' : 'progress'

  # TODO: move this conf somewhere else
  config.before do
    unless ENV['regenerate_cassettes']
      allow_any_instance_of(PROBTP::AttestationsCotisationsRetraite::MakeRequest).to receive(:http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(PROBTP::ConformitesCotisationsRetraite::MakeRequest).to receive(:http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })

      allow_any_instance_of(SIADE::V2::Drivers::EligibilitesCotisationRetraitePROBTP).to receive(:net_http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(SIADE::V2::Drivers::AttestationsCotisationRetraitePROBTP).to receive(:net_http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(SIADE::V2::Requests::EligibilitesCotisationRetraitePROBTP).to receive(:net_http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(SIADE::V2::Requests::AttestationsCotisationRetraitePROBTP).to receive(:net_http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(SIADE::V2::Requests::BilansEntreprisesBDF).to receive(:rest_client_options).and_return({ ssl_client_cert: nil, ssl_client_key: nil, verify_ssl: OpenSSL::SSL::VERIFY_NONE })
    end
  end

  config.before do
    # let's use a new instance of MockedRedis (in memory) for each specs
    allow(Redis).to receive(:current).and_return(MockRedis.new)
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!

  # rubocop:disable RSpec/BeforeAfterAll
  # Defer garbage collection to prevent it from running randomly as usual and slowing testing
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
  # rubocop:enable RSpec/BeforeAfterAll

  config.include ResponsesHelper, type: :controller
  config.include ResponsesHelper, type: :request
  config.include CommonErrorsMessagesHelpers

  config.include ProviderStubs::MSACotisations
  config.include ProviderStubs::DGFIPAttestationsFiscales

  if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']
    config.include MockCallSystemForCi

    config.before do
      make_qpdf_call_safe_on_memory_error!
    end
  end

  config.include ActivateStrictVcrRequestMatchingForV3
  config.extend ActivateStrictVcrRequestMatchingForV3

  config.around do |example|
    example = add_strict_matching_on_vcr_requests_for_v3(example)
    example.run
  end

  config.include_context 'has a provider_name', type: :provider_request
  config.include_context 'has a provider_name', type: :provider_response
  config.include_context 'has a provider_name', type: :provider_driver
  config.include_context 'with generator', type: :generator
end
