require 'rails_helper'

RSpec.describe QUALIBAT::CertificationsBatiment::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  let(:response) { QUALIBAT::CertificationsBatiment::MakeRequest.call(params:).response }

  let(:params) do
    {
      siret:
    }
  end

  context 'with a http ok', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with http ok but an empty body' do
    let(:response) { instance_double(Net::HTTPOK, body: '', code: '200') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a not found response', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  describe 'non-regression test: SSL error' do
    let(:body_ssl_error) do
      <<-BODY
      <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
      <html><head>
      <title>500 Proxy Error</title>
      </head><body>
      <h1>Proxy Error</h1>
      The proxy server could not handle the request<p>Reason: <strong>Error during SSL Handshake with remote server</strong></p><p />
      <hr>
      <address>Apache/2.4.54 (Debian) Server at mps.qualibat.eu Port 443</address>
      </body></html>
      BODY
    end

    let(:response) { instance_double(Net::HTTPBadGateway, body: body_ssl_error, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end
end
