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
              nom_naissance: 'CHAMPION',
              nom_usage: 'DU MONDE',
              prenoms: 'JEAN-PASCAL ROMAIN',
              annee_date_de_naissance: '1980',
              mois_date_de_naissance: '06',
              jour_date_de_naissance: '12',
              date_naissance: '1980-06-12',
              sexe: 'M'
            },
            {
              nom_naissance: 'NIDOUILLET',
              nom_usage: nil,
              prenoms: 'JOSIANE',
              annee_date_de_naissance: '1981',
              mois_date_de_naissance: '05',
              jour_date_de_naissance: '02',
              date_naissance: '1981-05-02',
              sexe: 'F'
            }
          ],
          enfants: [
            {
              nom_naissance: 'CHAMPION',
              nom_usage: nil,
              prenoms: 'AURELIE',
              annee_date_de_naissance: '2014',
              mois_date_de_naissance: '05',
              jour_date_de_naissance: '02',
              date_naissance: '2014-05-02',
              sexe: 'F'
            },
            {
              nom_naissance: 'CHAMPION',
              nom_usage: nil,
              prenoms: 'AURELIEN',
              annee_date_de_naissance: '2012',
              mois_date_de_naissance: '04',
              jour_date_de_naissance: nil,
              date_naissance: '2012-04-00',
              sexe: 'M'
            }
          ],
          adresse:
          {
            destinataire: 'DU MONDE JEAN-PASCAL',
            complement_information: 'APPARTEMENT 2',
            complement_information_geographique: nil,
            numero_libelle_voie: nil,
            lieu_dit: nil,
            code_postal_ville: '81700 GARREVAQUES',
            pays: 'FRANCE'
          },
          quotient_familial: {
            fournisseur: 'CNAF',
            valeur: 464,
            annee: 2023,
            mois: 6,
            annee_calcul: 2021,
            mois_calcul: 3
          }
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
              nom_naissance: 'CHAMPION',
              nom_usage: 'DU MONDE',
              prenoms: 'JEAN-PASCAL ROMAIN',
              annee_date_de_naissance: '1980',
              mois_date_de_naissance: '06',
              jour_date_de_naissance: '12',
              date_naissance: '1980-06-12',
              sexe: 'M'
            },
            {
              nom_naissance: 'NIDOUILLET',
              nom_usage: nil,
              prenoms: 'JOSIANE',
              annee_date_de_naissance: '1981',
              mois_date_de_naissance: '05',
              jour_date_de_naissance: '02',
              date_naissance: '1981-05-02',
              sexe: 'F'
            }
          ],
          enfants: [],
          adresse:
          {
            destinataire: 'DU MONDE JEAN-PASCAL',
            complement_information: 'APPARTEMENT 2',
            complement_information_geographique: nil,
            numero_libelle_voie: nil,
            lieu_dit: nil,
            code_postal_ville: '81700 GARREVAQUES',
            pays: 'FRANCE'
          },
          quotient_familial: {
            fournisseur: 'CNAF',
            valeur: 464,
            annee: 2023,
            mois: 6,
            annee_calcul: 2021,
            mois_calcul: 3
          }
        }
      )
    end
  end

  describe 'non-regression test: no given mois annee' do
    subject { instance.bundled_data.data.to_h }

    let(:params) do
      {}
    end

    it do
      expect(subject).to eq(
        {
          allocataires: [
            {
              nom_naissance: 'CHAMPION',
              nom_usage: 'DU MONDE',
              prenoms: 'JEAN-PASCAL ROMAIN',
              annee_date_de_naissance: '1980',
              mois_date_de_naissance: '06',
              jour_date_de_naissance: '12',
              date_naissance: '1980-06-12',
              sexe: 'M'
            },
            {
              nom_naissance: 'NIDOUILLET',
              nom_usage: nil,
              prenoms: 'JOSIANE',
              annee_date_de_naissance: '1981',
              mois_date_de_naissance: '05',
              jour_date_de_naissance: '02',
              date_naissance: '1981-05-02',
              sexe: 'F'
            }
          ],
          enfants: [
            {
              nom_naissance: 'CHAMPION',
              nom_usage: nil,
              prenoms: 'AURELIE',
              annee_date_de_naissance: '2014',
              mois_date_de_naissance: '05',
              jour_date_de_naissance: '02',
              date_naissance: '2014-05-02',
              sexe: 'F'
            },
            {
              nom_naissance: 'CHAMPION',
              nom_usage: nil,
              prenoms: 'AURELIEN',
              annee_date_de_naissance: '2012',
              mois_date_de_naissance: '04',
              jour_date_de_naissance: nil,
              date_naissance: '2012-04-00',
              sexe: 'M'
            }
          ],
          adresse:
          {
            destinataire: 'DU MONDE JEAN-PASCAL',
            complement_information: 'APPARTEMENT 2',
            complement_information_geographique: nil,
            numero_libelle_voie: nil,
            lieu_dit: nil,
            code_postal_ville: '81700 GARREVAQUES',
            pays: 'FRANCE'
          },
          quotient_familial: {
            fournisseur: 'CNAF',
            valeur: 464,
            annee: Time.zone.today.year.to_i,
            mois: Time.zone.today.month.to_i,
            annee_calcul: 2021,
            mois_calcul: 3
          }
        }
      )
    end
  end
end
