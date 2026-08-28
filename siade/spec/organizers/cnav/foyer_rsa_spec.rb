RSpec.describe CNAV::FoyerRSA, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_particulier_v3_cnav_foyer_rsa_with_civility', recipient: '13002526500013') }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      code_cog_insee_pays_naissance:,
      sexe_etat_civil:,
      request_id: SecureRandom.uuid
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { %w[jean charlie] }
  let(:annee_date_naissance) { 2008 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 1 }
  let(:code_cog_insee_commune_naissance) { nil }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  describe 'valid params' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the mocked foyer' do
      resource = subject.mocked_data[:payload]

      expect(resource.dig('data', 'beneficiaires')).to be_present
    end
  end

  describe 'invalid params' do
    let(:sexe_etat_civil) { 'invalid' }

    it { is_expected.to be_a_failure }
  end
end
