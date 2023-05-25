RSpec.describe PoleEmploi::Statut::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params: { identifiant_pole_emploi: }, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:identifiant_pole_emploi) { 'whatever' }
  let(:body) { Rails.root.join('spec/fixtures/payloads/pole_emploi/statut_valid.json').read }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identifiant: identifiant_pole_emploi,
          civilite: 'M.',
          nom: 'DUPONT',
          nomUsage: nil,
          prenom: 'JEAN',
          sexe: 'Masculin',
          dateNaissance: '1990-01-01T00:00:00+01:00',
          email: 'jean.dupont@france.fr',
          telephone: '0636656565',
          telephone2: nil,
          dateInscription: '2020-01-01T00:00:00+01:00',
          dateCessationInscription: nil,
          codeCertificationCNAV: 'VC',
          codeCategorieInscription: '1',
          libelleCategorieInscription: 'PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS',
          adresse: {
            INSEECommune: '75107',
            codePostal: '75007',
            ligneComplementAdresse: nil,
            ligneComplementDestinataire: 'APPARTEMENT 42',
            ligneComplementDistribution: nil,
            ligneNom: 'DUPONT',
            ligneVoie: '42 RUE DE LA PAIX',
            localite: '75001 PARIS'
          }
        }
      )
    end
  end
end
