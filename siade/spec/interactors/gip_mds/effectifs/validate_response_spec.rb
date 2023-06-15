RSpec.describe GIPMDS::Effectifs::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'GIP-MDS') }

  let(:response) do
    instance_double(Net::HTTPOK, code:, body:)
  end

  context 'with a status OK' do
    let(:code) { '200' }

    context 'when there at least one effectif with a valid count' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: '16.64'
          },
          {
            source: 'RG',
            effectifs: 'NC'
          }
        ].shuffle.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when all effectifs have no valid count' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: 'NC'
          },
          {
            source: 'RG',
            effectifs: 'NC'
          }
        ].to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when array does not contains at least RA and RG source' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: 'NC'
          }
        ].to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with an invalid body' do
      let(:body) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a code key and KO_TECHNIQUE' do
      let(:body) do
        {
          code: 'KO_TECHNIQUE'
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(GIPMDSError)) }
    end
  end

  context 'with a 204 status' do
    let(:code) { '204' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 401 status' do
    let(:code) { '401' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(GIPMDSError)) }
  end

  context 'with unknown provider code' do
    let(:code) { '66' }
    let(:body) { 'execute order' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(an_instance_of(ProviderUnknownError)) }
  end
end
