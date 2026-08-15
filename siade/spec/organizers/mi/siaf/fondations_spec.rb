RSpec.describe MI::SIAF::Fondations, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_entreprise_v3_mi_siaf_fondations', recipient: '13002526500013') }

  let(:params) do
    {
      siren_or_siret_or_rnf: valid_rnf_id
    }
  end

  describe 'valid params' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the mocked fondation' do
      resource = subject.mocked_data[:payload]

      expect(resource.dig('data', 'identifiants', 'rnf')).to eq(valid_rnf_id)
    end
  end

  describe 'invalid params' do
    let(:params) do
      {
        siren_or_siret_or_rnf: invalid_rnf_id
      }
    end

    it { is_expected.to be_a_failure }
  end
end
