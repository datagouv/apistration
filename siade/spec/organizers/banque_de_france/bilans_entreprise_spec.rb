RSpec.describe BanqueDeFrance::BilansEntreprise, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:,
        user_id:,
        request_id:
      }
    end

    let(:user_id) { SecureRandom.uuid }
    let(:request_id) { SecureRandom.uuid }

    let(:resource_collection) { subject.bundled_data.data }

    before do
      mock_valid_dgfip_dictionnaire(2020)
      mock_valid_dgfip_dictionnaire(2021)
    end

    context 'with valid siren' do
      let(:siren) { valid_siren(:bilan_entreprise_bdf) }

      before do
        mock_valid_banque_de_france
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection' do
        expect(resource_collection).to be_present
      end
    end
  end
end
