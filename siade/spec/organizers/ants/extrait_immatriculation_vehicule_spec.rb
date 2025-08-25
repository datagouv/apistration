RSpec.describe ANTS::ExtraitImmatriculationVehicule, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_particulier_v3_ants_extrait_immatriculation_vehicule_with_civility', recipient: '13002526500013') }

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

  let(:immatriculation) { 'TT-939-WA' }
  let(:nom_naissance) { 'DUPONT' }
  let(:prenoms) { %w[JEAN] }
  let(:annee_date_naissance) { 2000 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 1 }
  let(:code_cog_insee_commune_naissance) { '75101' }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  describe 'valid params' do
    before do
      stub_ants_extrait_immatriculation_vehicule_valid
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
