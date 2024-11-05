RSpec.describe CNOUS::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  context 'when response has a json birthPlace key' do
    let(:body) { read_payload_file('cnous/student_scholarship_valid_response.json') }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            identite: {
              nom: 'Martin',
              prenoms: %w[Jerome Francis],
              date_naissance: '1980-11-14',
              nom_commune_naissance: 'La Crèche',
              sexe: 'M'
            },
            est_boursier: true,
            echelon_bourse: {
              echelon: '5',
              echelon_bourse_regionale_provisoire: true
            },
            email: 'francislalanne@gmail.com',
            periode_versement_bourse: {
              date_rentree: '2020-09-01',
              duree: 12
            },
            statut_bourse: {
              code: 0,
              libelle: 'définitif'
            },
            etablissement_etudes: {
              nom_commune: 'MONTPELLIER',
              nom_etablissement: 'UFR SCIENCES TECHNOLOG SANTE'
            }
          }
        )
      end
    end
  end

  context 'when response has a null birthPlace key (takes birthPlaceLibelle instead)' do
    let(:body) { read_payload_file('cnous/student_scholarship_valid_response_without_birthplace.json') }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            identite: {
              nom: 'Martin',
              prenoms: %w[Jerome Francis],
              date_naissance: '1980-11-14',
              nom_commune_naissance: 'La Crèche',
              sexe: 'M'
            },
            est_boursier: true,
            echelon_bourse: {
              echelon: '5',
              echelon_bourse_regionale_provisoire: true
            },
            email: 'francislalanne@gmail.com',
            periode_versement_bourse: {
              date_rentree: '2020-09-01',
              duree: 12
            },
            statut_bourse: {
              code: 0,
              libelle: 'définitif'
            },
            etablissement_etudes: {
              nom_commune: 'MONTPELLIER',
              nom_etablissement: 'UFR SCIENCES TECHNOLOG SANTE'
            }
          }
        )
      end
    end
  end
end
