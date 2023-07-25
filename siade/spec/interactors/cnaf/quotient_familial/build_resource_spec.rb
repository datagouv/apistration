RSpec.describe CNAF::QuotientFamilial::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) { read_payload_file('cnaf/quotient_familial_valid_response.mime') }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          allocataires: [
            {
              nomPrenom: 'MARIE DUPONT',
              dateDeNaissance: '01031988',
              sexe: 'F'
            },
            {
              nomPrenom: 'JEAN DUPONT',
              dateDeNaissance: '01041990',
              sexe: 'M'
            }
          ],
          enfants: [
            {
              nomPrenom: 'JACQUES DUPONT',
              dateDeNaissance: '01012010',
              sexe: 'M'
            },
            {
              nomPrenom: 'JEANNE DUPONT',
              dateDeNaissance: '01022012',
              sexe: 'F'
            }
          ],
          adresse: {
            identite: 'Monsieur JEAN DUPONT',
            complementIdentite: 'APPARTEMENT 51',
            complementIdentiteGeo: 'RESIDENCE DES COLOMBES',
            numeroRue: '42 RUE DE LA PAIX',
            lieuDit: 'ILOTS DES OISEAUX',
            codePostalVille: '75002 PARIS',
            pays: 'FRANCE'
          },
          quotientFamilial: 1234,
          mois: 7,
          annee: 2022
        }
      )
    end
  end
end
