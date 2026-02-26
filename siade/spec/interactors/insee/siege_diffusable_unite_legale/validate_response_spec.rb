RSpec.describe INSEE::SiegeDiffusableUniteLegale::ValidateResponse, type: :validate_response do
  subject(:validator) { described_class.call(response:, provider_name: 'INSEE') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    let(:body) do
      {
        headers: {
          total:
        },
        etablissements: [
          {
            'statutDiffusionEtablissement' => status_diffusion
          }
        ] * total
      }.to_json
    end
    let(:status_diffusion) { 'O' }

    context 'when body has only 1 result' do
      let(:total) { 1 }

      context 'when etablissement is diffusable' do
        let(:status_diffusion) { 'O' }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when etablissement is partial diffusable' do
        let(:status_diffusion) { 'P' }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when etablissement is not diffusable' do
        let(:status_diffusion) { 'N' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'when body has more than 1 result' do
      let(:total) { 9001 }

      it { is_expected.to be_a_failure }

      it 'has an INSEE error for this result' do
        error = validator.errors.first

        expect(error.detail).to eq('L\'INSEE a répondu avec une réponse comportant plusieurs établissements')
      end
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

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a 500 error' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
