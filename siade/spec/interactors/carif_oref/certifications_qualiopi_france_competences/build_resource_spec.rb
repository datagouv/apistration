RSpec.describe CarifOref::CertificationsQualiopiFranceCompetences::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('carif_oref/qualiopi/valid.json') }

  let(:valid_payload) do
    {
      siret: '12000101100010',
      code_uai: nil,
      unite_legale_avec_plusieurs_nda: false,
      declarations_activites_etablissement: [
        {
          numero_de_declaration: '12345671234',
          actif: true,
          date_derniere_declaration: '2021-01-31',
          date_fin_exercice: '2022-12-31',
          certification_qualiopi: {
            action_formation: true,
            bilan_competences: false,
            validation_acquis_experience: true,
            apprentissage: true,
            obtention_via_unite_legale: false
          },
          specialites: {
            specialite_1: {
              code: '114',
              libelle: 'Mathématiques, statistiques'
            },
            specialite_2: {
              code: '128',
              libelle: 'Droit, sciences politiques'
            },
            specialite_3: {
              code: '314',
              libelle: 'Comptabilité, gestion'
            }
          }
        }
      ],
      habilitations_france_competence: [
        { code: 'RNCP09001',
          actif: true,
          date_actif: nil,
          date_fin_enregistrement: '2024-01-01',
          date_decision: nil,
          habilitation_pour_former: true,
          habilitation_pour_organiser_l_evaluation: true,
          sirets_organismes_certificateurs: [
            '13002526500013'
          ] }
      ]
    }
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it { is_expected.to eq(valid_payload) }
  end
end
