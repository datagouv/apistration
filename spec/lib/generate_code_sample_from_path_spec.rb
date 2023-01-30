require 'generate_code_sample_from_path'

RSpec.describe GenerateCodeSampleFromPath do
  describe '#perform' do
    subject { described_class.new(path, params, api_kind).perform }

    context 'when api kind is API Entreprise' do
      let(:api_kind) { 'api_entreprise' }
      let(:path) { '/api/{siret}' }
      let(:params) { { 'siret' => '123456789012' } }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when api kind is API Particulier' do
      let(:api_kind) { 'api_particulier' }
      let(:path) { '/v2/individu' }
      let(:params) { { 'whatever' => 'whatever' } }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when api kind is France Connect' do
      let(:api_kind) { 'france_connect' }
      let(:path) { '/api/v1/whatever' }
      let(:params) { { 'token' => 'token' } }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end
  end
end

