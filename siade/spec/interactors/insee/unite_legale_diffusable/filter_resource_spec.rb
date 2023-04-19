RSpec.describe INSEE::UniteLegaleDiffusable::FilterResource, type: :filter_resource do
  subject { organizer }

  describe 'with an unite legale response' do
    let(:organizer) { described_class.call(builded_resources) }

    let(:builded_resources) { INSEE::UniteLegaleDiffusable::BuildUnfilteredResource.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body:) }

    context 'with a personne physique' do
      let(:body) { open_payload_file('insee/partially_diffusible_unite_legale_personne_physique.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siren) { is_expected.to eq('808861199') }
        its(:siret_siege_social) { is_expected.to eq('80886119900020') }
        its(:type) { is_expected.to eq(:personne_physique) }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: nil,
            sigle: nil
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            sexe: '[ND]',
            nom_naissance: '[ND]',
            nom_usage: '[ND]',
            prenom_1: '[ND]',
            prenom_2: '[ND]',
            prenom_3: '[ND]',
            prenom_4: '[ND]',
            prenom_usuel: '[ND]',
            pseudonyme: '[ND]'
          })
        end
      end
    end

    context 'with a personne morale' do
      let(:body) { open_payload_file('insee/partially_diffusible_unite_legale_personne_morale.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siren) { is_expected.to eq('243400819') }
        its(:siret_siege_social) { is_expected.to eq('24340081900013') }
        its(:type) { is_expected.to eq(:personne_morale) }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: 'COMMUNAUTE D AGGLOMERATION HERAULT MEDITERRANEE',
            sigle: '[ND]'
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            sexe: nil,
            nom_naissance: nil,
            nom_usage: nil,
            prenom_1: nil,
            prenom_2: nil,
            prenom_3: nil,
            prenom_4: nil,
            prenom_usuel: nil,
            pseudonyme: nil
          })
        end
      end
    end
  end
end
