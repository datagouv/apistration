# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'rspec/json_expectations'
require 'webmock/rspec'
require 'vcr_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }
Rails.root.glob('spec/factories/**/*.rb').each { |f| require f }
Rails.root.glob('lib/generators/**/*.rb').each { |f| require f }

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
  config.use_transactional_fixtures = true

  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.include(SelfHostedDoc, :self_hosted_doc)
  config.default_formatter = config.files_to_run.one? ? 'doc' : 'progress'

  # TODO: move this conf somewhere else
  config.before do
    unless ENV['regenerate_cassettes']
      allow_any_instance_of(BanqueDeFrance::BilansEntreprise::MakeRequest).to receive(:http_options).and_return({ use_ssl: true, verify_ssl: OpenSSL::SSL::VERIFY_NONE, cert: nil, key: nil })
      allow_any_instance_of(PROBTP::AttestationsCotisationsRetraite::MakeRequest).to receive(:http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
      allow_any_instance_of(PROBTP::ConformitesCotisationsRetraite::MakeRequest).to receive(:http_options).and_return({ use_ssl: true, ca_path: nil, ca_file: nil, cert: nil, key: nil })
    end
  end

  config.before(:all) do
    Token.delete_all
    Seeds.new.perform
  end

  config.before do
    Rails.cache.clear
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

  config.before(:all) do
    Rails.cache.clear
  end

  config.include ResponsesHelper, type: :controller
  config.include ResponsesHelper, type: :request
  config.include CommonErrorsMessagesHelpers
  config.include TokenHelpers

  config.include ProviderStubs::ANTS
  config.include ProviderStubs::MSACotisations
  config.include ProviderStubs::DGFIP
  config.include ProviderStubs::DSNJ
  config.include ProviderStubs::Infogreffe
  config.include ProviderStubs::CIBTP
  config.include ProviderStubs::CNAV
  config.include ProviderStubs::FranceConnect
  config.include ProviderStubs::CNOUSStudentScholarship
  config.include ProviderStubs::BanqueDeFrance
  config.include ProviderStubs::MEN
  config.include ProviderStubs::URSSAF
  config.include ProviderStubs::GIPMDS
  config.include ProviderStubs::Qualifelec
  config.include ProviderStubs::INSEE
  config.include ProviderStubs::INPI
  config.include ProviderStubs::INPI::RNE
  config.include ProviderStubs::MESRI
  config.include ProviderStubs::SDH
  config.include ProviderStubs::FranceTravail
  config.include ProviderStubs::DataSubvention

  config.include ActivateStrictVcrRequestMatchingForV3
  config.extend ActivateStrictVcrRequestMatchingForV3

  config.around do |example|
    example = add_strict_matching_on_vcr_requests_for_v3(example)
    example.run
  end

  config.before do
    allow_any_instance_of(INPI::RNE::Authenticate).to receive(:randomize_account!)
  end

  config.before(type: :request, api: :entreprise) do
    host! 'entreprise.api.localtest.me'
  end

  config.before(type: :request, api: :particulier) do
    host! 'particulier.api.localtest.me'
  end

  config.before(type: :request, api: :particulierv2) do
    host! 'particulier.api.localtest.me'
  end

  config.define_derived_metadata(type: :swagger) do |metadata|
    metadata[:swagger_doc] = "openapi-#{metadata[:api]}.yaml"
  end

  config.before(type: :validate_response) do
    if defined?(response)
      allow(response).to receive(:body).and_return('') unless response.respond_to?(:body)

      allow(response).to receive(:to_hash).and_return({
        'header' => 'value'
      })
    end

    allow(DataEncryptor).to receive(:new).and_return(
      instance_double(DataEncryptor, encrypt: 'stubbed_encrypted_data')
    )
  end

  config.after(type: :swagger) do |example|
    next unless example.metadata[:response][:code].dup.to_s == '200'

    controller = request.controller_class.new

    split_path_item = example.metadata[:path_item][:template].split('/')
    api_version = if example.metadata[:api] == :particulierv2
                    split_path_item[2][1..]
                  else
                    split_path_item[1][1..]
                  end

    controller.params = { api_version: }
    operation_id = controller.send(:operation_id)

    example.metadata[:response][:'x-operationId'] = operation_id
  end

  config.include_context 'has a provider_name', type: :provider_request
  config.include_context 'has a provider_name', type: :provider_response
  config.include_context 'has a provider_name', type: :provider_driver
  config.include_context 'with generator', type: :generator
  config.include_context 'retriever organizer', type: :retriever_organizer
end
