require 'rails_helper'

RSpec.describe QUALIBAT::CertificationsBatiment::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response) }

  let(:response) { QUALIBAT::CertificationsBatiment::MakeRequest.call(params: params).response }

  let(:params) do
    {
      siret: siret
    }
  end

  context 'with a http ok', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with http ok but an empty body' do
    let(:siret) { '47882868400017' }

    before do
      url_pattern = %r{mps.qualibat.eu/MPS/CERTIFICAT/\?SIRET=#{siret}}
      stub_request(:get, url_pattern).to_return({
        status: 200,
        body: ''
      })
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a not found response', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
