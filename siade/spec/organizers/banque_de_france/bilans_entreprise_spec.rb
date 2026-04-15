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

    context 'when DGFIP is down and dictionaries fall back to local files' do
      let(:siren) { valid_siren(:bilan_entreprise_bdf) }

      before do
        mock_valid_banque_de_france

        stub_request(:post, "#{Siade.credentials[:dgfip_apim_base_url]}/token")
          .to_return(status: 503)
        stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/dictionnaire})
          .to_return(status: 503)
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection with enriched declarations' do
        expect(resource_collection).to be_present
        expect(resource_collection.first.declarations).to be_present
      end
    end

    context 'when load_local_dgfip_dictionnaries feature flag is enabled' do
      let(:siren) { valid_siren(:bilan_entreprise_bdf) }

      before do
        mock_valid_banque_de_france

        AppConfig.reset(:features)
        allow(Rails.application).to receive(:config_for).and_call_original
        allow(Rails.application).to receive(:config_for).with(:features).and_return(load_local_dgfip_dictionnaries: true)
      end

      after do
        AppConfig.reset(:features)
      end

      it { is_expected.to be_a_success }

      it 'does not call DGFIP' do
        expect(CacheResourceRetriever).not_to receive(:call)

        subject
      end

      it 'retrieves the resource collection with enriched declarations' do
        expect(resource_collection).to be_present
        expect(resource_collection.first.declarations).to be_present
      end
    end
  end
end
