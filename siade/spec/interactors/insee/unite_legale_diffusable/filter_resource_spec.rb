RSpec.describe INSEE::UniteLegaleDiffusable::FilterResource, type: :filter_resource do
  subject { organizer }

  describe 'with an unite legale response' do
    let(:organizer) { described_class.call(builded_resources) }

    let(:builded_resources) { INSEE::UniteLegale::BuildResource.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body:) }

    let(:body) do
      INSEE::UniteLegale::MakeRequest.call(params:, token: 'valid insee token').response.body
    end

    let(:params) do
      {
        siren:
      }
    end

    context 'with an active GE, which is a personne physique' do
      before do
        mock_insee_partially_diffusible_unite_legale_personne_physique
      end

      let(:siren) { sirens_insee_v3_mock[:partially_diffusible_unite_legale_personne_physique] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: '[ND]',
            sigle: '[ND]'
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

    context 'with an active GE, which is a personne morale' do
      before do
        mock_insee_partially_diffusible_unite_legale_personne_morale
      end

      let(:siren) { sirens_insee_v3_mock[:partially_diffusible_unite_legale_personne_morale] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: 'COLLEGE MADAME DE SEVIGNE',
            sigle: '[ND]'
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            sexe: nil,
            nom_naissance: nil,
            nom_usage: nil,
            prenom_1: 'Thomas',
            prenom_2: 'Samuel',
            prenom_3: 'Loic',
            prenom_4: 'Alexandre',
            prenom_usuel: nil,
            pseudonyme: nil
          })
        end
      end
    end
  end
end
