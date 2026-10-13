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
        parametres_calcul_participation_familiale: hash_including(nombre_enfants_a_charge: 1)
      )
    end
  end

  describe 'the attestation proof' do
    let(:params) do
      {
        params: call_params,
        recipient:,
        generate_proof_mode: 'proof-only',
        scopes: %w[cnav_participation_familiale_eaje_allocataires],
        habilitation: 'a11b0000-0000-0000-0000-000000000042'
      }
    end

    context 'when the provider found the allocataire' do
      it 'is built once the chain has run' do
        expect(instance.verification_url).to be_present
      end
    end

    context 'when the provider rate-limits the call' do
      before do
        stub_request(:get, cnav_url('participation_familiale_eaje')).with(query: hash_including({})).to_return(status: 429, body: '{}')
      end

      it 'fails with the provider error and no proof' do
        expect(instance).to be_a_failure
        expect(instance.verification_url).to be_nil
      end
    end

    context 'when the chain crashes' do
      before do
        allow(CNAV::ParticipationFamilialeEAJE::BuildResource).to receive(:call!).and_raise(RuntimeError, 'boom')
      end

      it 'lets the crash surface unchanged' do
        expect { instance }.to raise_error(RuntimeError, 'boom')
      end
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
