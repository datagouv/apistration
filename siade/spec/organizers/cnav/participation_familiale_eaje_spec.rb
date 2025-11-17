require 'rails_helper'

RSpec.describe CNAV::ParticipationFamilialeEAJE do
  subject(:instance) { described_class.call(**params) }

  let(:params) do
    {
      params: call_params,
      recipient:
    }
  end
  let(:recipient) { valid_siret }

  let(:call_params) do
    {
      nom_naissance: 'CHAMPION',
      prenoms: ['JEAN-PASCAL'],
      annee_date_naissance: 1980,
      mois_date_naissance: 6,
      jour_date_naissance: 12,
      sexe_etat_civil: 'M',
      code_cog_insee_pays_naissance: '99100',
      code_cog_insee_commune_naissance: '17300',
      request_id: SecureRandom.uuid
    }
  end

  before do
    stub_cnav_authenticate('participation_familiale_eaje')
    stub_cnav_valid('participation_familiale_eaje')
  end

  it { is_expected.to be_a_success }

  describe 'bundled_data' do
    subject { instance.bundled_data.data.to_h }

    it 'returns properly structured resource' do
      expect(subject).to include(
        allocataires: array_including(
          hash_including(nom_naissance: 'DUPOND')
        ),
        enfants: array_including(
          hash_including(nom_naissance: 'DUPOND')
        ),
        adresse: hash_including(destinataire: 'M. DUPOND Jean-Michel'),
        parametres_calcul_participation_familiale: hash_including(annee: 2024)
      )
    end
  end

  describe 'provider_name' do
    it 'returns correct provider name' do
      expect(instance.provider_name).to eq('Sécurité sociale')
    end
  end

  describe 'dss_prestation_name' do
    it 'returns correct prestation name' do
      expect(instance.dss_prestation_name).to eq('participation_familiale_eaje')
    end
  end
end
