RSpec.describe Qualifelec::Certificats::BuildResourceCollection, type: :build_resource do
  subject { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:valid_collection) do
    [
      {
        document_url: 'https://pp.qualifelec.fr/certifmoteur/4/32456.pdf',
        numero: 10_929,
        rge: false,
        date_debut: '2022-10-19',
        date_fin: '2023-10-18',
        qualification: {
          label: 'Installations Électriques Logement Commerce Petit Tertiaire - LCPT',
          date_debut: '2022-10-19',
          date_fin: '2026-10-18',
          indices: [
            {
              'label' => 'LCPT1',
              'code' => 'LCPT1'
            },
            {
              'label' => 'LCPT2',
              'code' => 'LCPT2'
            }
          ],
          mentions: [
            {
              'label' => 'Colonnes Montantes 1',
              'code' => 'CMO1'
            },
            {
              'label' => 'Colonnes Montantes 2',
              'code' => 'CMO2'
            }
          ],
          domaines: [
            {
              'label' => 'Courants forts 1',
              'code' => 'CF1'
            },
            {
              'label' => 'Courants forts 2',
              'code' => 'CF2'
            }
          ],
          classification: {
            code: 4,
            label: 'Classe 4 - de 20 à 49 exécutants'
          }
        },
        assurance_decennale: {
          nom: 'AXA',
          date_debut: nil,
          date_fin: nil
        },
        assurance_civile: {
          nom: 'ALLIANZ IARD',
          date_debut: nil,
          date_fin: nil
        }
      },
      {
        document_url: 'https://pp.qualifelec.fr/certifmoteur/4/32463.pdf',
        numero: 10_928,
        rge: false,
        date_debut: '2022-10-19',
        date_fin: '2023-10-18',
        qualification: {
          label: 'Installations Électriques Moyen Gros Tertiaire Industrie - MGTI',
          date_debut: '2023-10-30',
          date_fin: '2027-10-30',
          indices: [
            {
              'label' => 'MGTI',
              'code' => 'MGTI'
            }
          ],
          mentions: [
            {
              'label' => 'Études',
              'code' => 'ET'
            }
          ],
          domaines: [],
          classification: {
            code: 4,
            label: 'Classe 4 - de 20 à 49 exécutants'
          }
        },
        assurance_decennale: {
          nom: 'AXE',
          date_debut: '2022-10-13',
          date_fin: '2027-10-30'
        },
        assurance_civile: {
          nom: 'DEODEBA',
          date_debut: '2022-10-13',
          date_fin: '2027-10-30'
        }
      }
    ]
  end

  let(:body) do
    Qualifelec::Certificats::MakeRequest.call(params:, token:).response.body
  end

  let(:params) do
    {
      siret:
    }
  end

  let(:siret) { valid_siret(:qualifelec) }
  let(:token) { 'SUPER TOKEN' }

  before do
    stub_qualifelec_certificates
  end

  it { is_expected.to be_a_success }

  it 'builds valid resources' do
    expect(subject.bundled_data.data).to all be_a(Resource)
  end

  it 'has valid resource_collection' do
    expect(subject.bundled_data.data.map(&:to_h)).to eq(valid_collection)
  end
end
