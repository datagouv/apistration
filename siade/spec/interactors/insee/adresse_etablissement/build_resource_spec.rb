RSpec.describe INSEE::AdresseEtablissement::BuildResource, type: :build_resource do
  subject { organizer.bundled_data.data }

  let(:organizer) { described_class.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }

  describe 'non-regression test: v3.11 adds complete typeVoieEtablissement (instead of shortcode)' do
    let(:body) { open_payload_file('insee/partially_diffusible_etablissement_personne_physique.json').read }

    its(:type_voie) { is_expected.to eq('AVENUE') }

    it do
      expect(subject.acheminement_postal[:l4]).to eq('32 AVENUE DU CHAMPS DE PATATE')
    end
  end
end
