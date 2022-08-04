require_relative '../provider_stubs'

module ProviderStubs::CNAFQuotientFamilial
  def mock_valid_cnaf_quotient_familial
    stub_cnaf_quotient_familial_make_request_ssl_config

    stub_request(:post, Siade.credentials[:cnaf_quotient_familial_url]).to_return(
      status: 200,
      body: File.read(Rails.root.join('spec/fixtures/payloads/cnaf_quotient_familial_valid_response.mime'))
    )
  end

  private

  # rubocop:disable RSpec/AnyInstance
  def stub_cnaf_quotient_familial_make_request_ssl_config
    allow_any_instance_of(CNAF::QuotientFamilial::MakeRequest).to receive(:ssl_certificate).and_return('ssl_certificate')
    allow_any_instance_of(CNAF::QuotientFamilial::MakeRequest).to receive(:ssl_certificate_key).and_return('ssl_certificate_key')
  end
  # rubocop:enable RSpec/AnyInstance
end
