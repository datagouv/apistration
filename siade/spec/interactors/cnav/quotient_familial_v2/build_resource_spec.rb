RSpec.describe CNAV::QuotientFamilialV2::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params:, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:params) do
    {
      annee: 2023,
      mois: 6
    }
  end

  let(:body) { read_payload_file('cnav/quotient_familial_v2/make_request_valid.json') }

  before do
    allow(response).to receive(:[]).with('X-APISECU-FD').and_return('00810011')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          allocataires: [
            {
              nomNaissance: 'CHAMPION',
              nomUsuel: 'DU MONDE',
              prenoms: 'JEAN-PASCAL ROMAIN',
              anneeDateDeNaissance: '1980',
              moisDateDeNaissance: '06',
              jourDateDeNaissance: '12',
              sexe: 'M'
            },
            {
              nomNaissance: 'NIDOUILLET',
              nomUsuel: nil,
              prenoms: 'JOSIANE',
              anneeDateDeNaissance: '1981',
              moisDateDeNaissance: '05',
              jourDateDeNaissance: '02',
              sexe: 'F'
            }
          ],
          enfants: [
            {
              nomNaissance: 'CHAMPION',
              nomUsuel: nil,
              prenoms: 'AURELIE',
              anneeDateDeNaissance: '2014',
              moisDateDeNaissance: '05',
              jourDateDeNaissance: '02',
              sexe: 'F'
            },
            {
              nomNaissance: 'CHAMPION',
              nomUsuel: nil,
              prenoms: 'AURELIEN',
              anneeDateDeNaissance: '2012',
              moisDateDeNaissance: '04',
              jourDateDeNaissance: nil,
              sexe: 'M'
            }
          ],
          adresse:
          {
            identite: 'DU MONDE JEAN-PASCAL',
            complementInformation: 'APPARTEMENT 2',
            complementInformationGeographique: nil,
            numeroLibelleVoie: nil,
            lieuDit: nil,
            codePostalVille: '81700 GARREVAQUES',
            pays: 'FRANCE'
          },
          regime: 'CNAF',
          quotientFamilial: 464,
          annee: 2023,
          mois: 6,
          annee_calcul: 2021,
          mois_calcul: 3
        }
      )
    end
  end

  describe 'non-regression test: resource without children' do
    subject { instance.bundled_data.data.to_h }

    let(:body) { read_payload_file('cnav/quotient_familial_v2/make_request_valid_without_children.json') }

    it do
      expect(subject).to eq(
        {
          allocataires: [
            {
              nomNaissance: 'CHAMPION',
              nomUsuel: 'DU MONDE',
              prenoms: 'JEAN-PASCAL ROMAIN',
              anneeDateDeNaissance: '1980',
              moisDateDeNaissance: '06',
              jourDateDeNaissance: '12',
              sexe: 'M'
            },
            {
              nomNaissance: 'NIDOUILLET',
              nomUsuel: nil,
              prenoms: 'JOSIANE',
              anneeDateDeNaissance: '1981',
              moisDateDeNaissance: '05',
              jourDateDeNaissance: '02',
              sexe: 'F'
            }
          ],
          enfants: [],
          adresse:
          {
            identite: 'DU MONDE JEAN-PASCAL',
            complementInformation: 'APPARTEMENT 2',
            complementInformationGeographique: nil,
            numeroLibelleVoie: nil,
            lieuDit: nil,
            codePostalVille: '81700 GARREVAQUES',
            pays: 'FRANCE'
          },
          regime: 'CNAF',
          quotientFamilial: 464,
          annee: 2023,
          mois: 6,
          annee_calcul: 2021,
          mois_calcul: 3
        }
      )
    end
  end
end
