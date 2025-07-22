RSpec.describe ANTS::DossierImmatriculation, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_particulier_v3_ants_dossier_immatriculation_with_civility', recipient: '13002526500013') }

  let(:params) do
    {
      immatriculation:,
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      code_cog_insee_pays_naissance:,
      sexe_etat_civil:
    }
  end

  let(:immatriculation) { 'AA-123-AA' }
  let(:nom_naissance) { 'Sekiro' }
  let(:prenoms) { %w[Shinobi Wolf] }
  let(:annee_date_naissance) { 2008 }
  let(:mois_date_naissance) { 3 }
  let(:jour_date_naissance) { 22 }
  let(:code_cog_insee_commune_naissance) { '92036' }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  describe 'valid params' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
      allow(MockDataBackend).to receive(:get_response_for).and_return(
        {
          status: '200',
          payload: {
            test: 'lol'
          }
        }
      )
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.mocked_data[:payload]

      expect(resource).to be_present
    end
  end
end
