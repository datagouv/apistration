RSpec.describe MEN::Scolarites::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  context 'when using v1' do
    let(:body) { open_payload_file('men/scolarites/valid.json').read }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      context 'without bourse' do
        let(:valid_resource) do
          {
            identite: {
              nom: 'NOMFAMILLE',
              prenom: 'prenom',
              sexe: 'F',
              date_naissance: '2000-06-10'
            },
            annee_scolaire: '2021',
            est_scolarise: true,
            est_boursier: false,
            echelon_bourse: nil,
            module_elementaire_formation: {
              code_mef_stat: nil,
              libelle: nil
            },
            etablissement: {
              code_uai: '0511474A',
              code_ministere_tutelle: nil
            },
            statut_eleve: {
              code: 'ST',
              libelle: 'SCOLAIRE'
            },
            regime_pensionnat: nil
          }
        end

        it { is_expected.to eq(valid_resource) }
      end

      context 'with bourse' do
        let(:body) { open_payload_file('men/scolarites/valid_with_bourse.json').read }
        let(:valid_resource) do
          {
            identite: {
              nom: 'NOMFAMILLE',
              prenom: 'prenom',
              sexe: 'F',
              date_naissance: '2000-06-10'
            },
            annee_scolaire: '2021',
            est_scolarise: true,
            est_boursier: true,
            echelon_bourse: 1,
            etablissement: {
              code_uai: '0511474A',
              code_ministere_tutelle: nil
            },
            module_elementaire_formation: {
              code_mef_stat: nil,
              libelle: nil
            },
            statut_eleve: {
              code: 'ST',
              libelle: 'SCOLAIRE'
            },
            regime_pensionnat: nil
          }
        end

        it { expect(subject).to eq(valid_resource) }
      end

      context 'with bourse unknown' do
        let(:body) { open_payload_file('men/scolarites/unknown_bourse.json').read }
        let(:valid_resource) do
          {
            identite: {
              nom: 'NOMFAMILLE',
              prenom: 'prenom',
              sexe: 'F',
              date_naissance: '2000-06-10'
            },
            annee_scolaire: '2021',
            est_scolarise: true,
            est_boursier: nil,
            echelon_bourse: nil,
            etablissement: {
              code_uai: '0511474A',
              code_ministere_tutelle: nil
            },
            module_elementaire_formation: {
              code_mef_stat: nil,
              libelle: nil
            },
            statut_eleve: {
              code: 'ST',
              libelle: 'SCOLAIRE'
            },
            regime_pensionnat: nil
          }
        end

        it { expect(subject).to eq(valid_resource) }
      end
    end
  end

  context 'when using v2' do
    let(:body) { open_payload_file('men/scolarites/valid_v2.json').read }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      let(:valid_resource) do
        {
          identite: {
            nom: 'Martin',
            prenom: 'Camille',
            sexe: 'M',
            date_naissance: '2007-07-07'
          },
          annee_scolaire: '2023',
          est_scolarise: true,
          est_boursier: nil,
          echelon_bourse: nil,
          module_elementaire_formation: {
            code_mef_stat: '211324099991',
            libelle: nil
          },
          etablissement: {
            code_uai: '0890003V',
            code_ministere_tutelle: '06'
          },
          statut_eleve: {
            code: 'ST',
            libelle: 'SCOLAIRE'
          },
          regime_pensionnat: {
            code: '0',
            libelle: 'Externe libre'
          }
        }
      end

      it { is_expected.to eq(valid_resource) }
    end
  end
end
