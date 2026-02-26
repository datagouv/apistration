RSpec.describe INSEE::EtablissementDiffusable::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INSEE') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: payload.to_json) }

    let(:payload) do
      {
        etablissement: {
          statutDiffusionEtablissement: diffusable
        }
      }
    end

    context 'when it is a non-diffusable etablissement' do
      let(:diffusable) { 'N' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when it is a partial diffusable etablissement' do
      let(:diffusable) { 'P' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is a diffusable etablissement' do
      let(:diffusable) { 'O' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end

  context 'with a http ok but HTML body' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '<!DOCTYPE html><html></html>', to_hash: {}) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a forbidden error' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnavailableForLegalReasonsError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
