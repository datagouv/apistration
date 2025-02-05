require 'rails_helper'

RSpec.describe QUALIBAT::CertificationsBatiment::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  let(:response) { QUALIBAT::CertificationsBatiment::MakeRequest.call(params:, token:).response }

  let(:params) do
    {
      siret:
    }
  end
  let(:token) { QUALIBAT::CertificationsBatiment::Authenticate.call.token }

  context 'with a http ok', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret_2' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with http ok but an empty body' do
    let(:response) { instance_double(Net::HTTPOK, body: '', code: '200') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(BadFileFromProviderError)) }

    it 'tracks error on MonitoringService' do
      expect(MonitoringService.instance).to receive(:track).with(
        'info',
        'Qualibat: empty file'
      )

      subject
    end
  end

  context 'with another http code' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a not found response', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret_2' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
