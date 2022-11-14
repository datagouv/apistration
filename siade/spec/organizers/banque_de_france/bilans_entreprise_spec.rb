RSpec.describe BanqueDeFrance::BilansEntreprise, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    let(:resource_collection) { subject.bundled_data.data }

    before do
      VCR.use_cassette('dgfip/dictionaries/2020_and_2021') do
        retrieve_dgfip_dictionaries(%w[2020 2021])
      end
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
