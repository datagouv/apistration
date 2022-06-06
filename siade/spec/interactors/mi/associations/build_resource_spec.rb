RSpec.describe MI::Associations::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'mi/associations/with_valid_siret' } do
    subject { described_class.call(response:) }

    let(:valid_payload) do
      {
        rna_id: 'W751227325',
        titre: 'LA PRÉVENTION ROUTIERE',
        objet: 'Accroitre la sécurité des usagers en encourageant toutes mesures ou initiatives propres à réduire les accidents',
        siret: nil,
        siret_siege_social: '77571979202650',
        date_creation: '1955-01-01',
        date_declaration: '1955-01-01',
        date_publication: nil,
        date_dissolution: nil,
        adresse_siege:
                                {
                                  complement: '  ',
                                  numero_voie: '33',
                                  type_voie: 'RUE',
                                  libelle_voie: 'de Mogador',
                                  distribution: nil,
                                  code_insee: '75108',
                                  code_postal: '75009',
                                  commune: 'Paris'
                                },
        etat: 'true',
        groupement: nil,
        mise_a_jour: '1955-01-01'
      }
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      MI::Associations::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siret_or_rna: valid_rna_id
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.to_h).to eq(valid_payload)
    end
  end
end
