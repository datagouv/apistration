require 'api_gouv_commons'

module TestClientSupport
  BASE_URLS = {
    ApiGouvCommons::Configuration::PRODUCTION => 'https://example.test',
    ApiGouvCommons::Configuration::STAGING => 'https://staging.example.test'
  }.freeze

  module_function

  def build_client(overrides = {})
    config = ApiGouvCommons::Configuration.new(
      base_urls: BASE_URLS,
      token: 'test-token',
      default_params: overrides.delete(:default_params) ||
        { recipient: '13002526500013', context: 'ctx', object: 'obj' },
      **overrides
    )
    ApiGouvCommons::ClientBase.new(config, product: :entreprise)
  end
end
