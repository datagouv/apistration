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

  context 'with a http ok' do
    let(:siret) { valid_siret(:qualibat) }

    # `around` (not `before`) so the stub is registered ahead of the
    # `config.before(type: :validate_response)` hook, which forces `response`
    # to be evaluated (and thus the real HTTP call to fire) before any
    # example-level `before(:each)` hook would run.
    around do |example|
      stub_qualibat_authenticate
      stub_qualibat_valid_siret
      example.run
    end

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

  context 'with a not found response' do
    let(:siret) { not_found_siret(:qualibat) }

    around do |example|
      stub_qualibat_authenticate
      stub_qualibat_not_found_siret
      example.run
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
