RSpec.describe MEN::Scolarites::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) { open_payload_file('men/scolarites/valid.json').read }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    context 'without bourse' do
      let(:valid_resource) do
        {
          eleve: {
            nom: 'NOMFAMILLE',
            prenom: 'prenom',
            sexe: 'F',
            date_naissance: '2000-06-10'
          },
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          est_scolarise: true,
          est_boursier: nil,
          niveau_bourse: nil,
          status_eleve: {
            code: 'ST',
            libelle: 'SCOLAIRE'
          }
        }
      end

      it { is_expected.to eq(valid_resource) }
    end

    context 'with bourse' do
      let(:body) { open_payload_file('men/scolarites/valid_with_bourse.json').read }
      let(:valid_resource) do
        {
          eleve: {
            nom: 'NOMFAMILLE',
            prenom: 'prenom',
            sexe: 'F',
            date_naissance: '2000-06-10'
          },
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          est_scolarise: true,
          est_boursier: nil,
          niveau_bourse: nil,
          status_eleve: {
            code: 'ST',
            libelle: 'SCOLAIRE'
          }
        }
      end

      it { expect(subject).to eq(valid_resource) }
    end
  end
end
