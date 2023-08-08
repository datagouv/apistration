RSpec.describe INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }
    let(:body) do
      read_payload_file('inpi/rne/valid.json')
    end

    let(:excluded_modalites) { described_class.new.send(:excluded_modalites) }

    let(:valid_collection) do
      [
        {
          nom: 'DUPONT',
          nom_usage: 'DUBOIS',
          prenoms: %w[JEAN MARC],
          date_naissance: {
            annee: '1989',
            mois: '01'
          },
          modalites: {
            detention_part_directe: true,
            detention_part_directe_rdd: 49.0,
            parts_directes_pleine_propriete: 49.0,
            parts_directes_nue_propriete: 0.0,
            detention_part_indirecte: false,
            detention_part_indirecte_rdd: 0.0,
            parts_indirectes_indivision: 0.0,
            parts_indirectes_indivision_pleine_propriete: 0.0,
            parts_indirectes_indivision_nue_propriete: 0.0,
            parts_indirectes_personnes_morales: 0.0,
            parts_indirectes_personnes_morales_pleine_propriete: 0.0,
            parts_indirectes_personnes_morales_nue_propriete: 0.0,
            detention_part_totale: 49.0,
            detention_vote_directe: true,
            detention_vote_directe_rdd: 49.0,
            vote_directe_pleine_propriete: 49.0,
            vote_directe_nue_propriete: 0.0,
            vote_directe_usufruit: 0.0,
            detention_vote_indirecte: false,
            detention_vote_indirecte_rdd: 0.0,
            vote_indirecte_indivision: 0.0,
            vote_indirecte_indivision_pleine_propriete: 0.0,
            vote_indirecte_indivision_nue_propriete: 0.0,
            vote_indirecte_indivision_usufruit: 0.0,
            vote_indirecte_personnes_morales: 0.0,
            vote_indirecte_personnes_morales_pleine_propriete: 0.0,
            vote_indirecte_personnes_morales_nue_propriete: 0.0,
            vote_indirecte_personnes_morales_usufruit: 0.0,
            vocation_titulaire_directe_pleine_propriete_rdd: false,
            vocation_titulaire_directe_pleine_propriete: 0.0,
            vocation_titulaire_directe_nue_propriete: 0.0,
            vocation_titulaire_indirecte_indivision: 0.0,
            vocation_titulaire_indirecte_pleine_propriete_rdd: false,
            vocation_titulaire_indirecte_pleine_propriete: 0.0,
            vocation_titulaire_indirecte_nue_propriete: 0.0,
            vocation_titulaire_indirecte_personnes_morales: 0.0,
            vocation_titulaire_indirecte_personnes_morales_pleine_propriete: 0.0,
            vocation_titulaire_indirecte_personnes_morales_nue_propriete: 0.0,
            detention_vote_total: 0.0,
            detention_pouvoir_decision_ag: false,
            detention_pouvoir_nommage_membres_conseil_admin: false,
            detention_autres_moyens_controle: false,
            representant_legal: false,
            representant_legal_placement_sans_gestion_delegue: false
          }.except(*excluded_modalites)
        },
        {
          nom: 'MARTIN',
          nom_usage: nil,
          prenoms: %w[JULES ANDRE],
          date_naissance: {
            annee: '1990',
            mois: '01'
          },
          modalites: {
            detention_part_directe: true,
            detention_part_directe_rdd: 51.0,
            parts_directes_pleine_propriete: 51.0,
            parts_directes_nue_propriete: 0.0,
            detention_part_indirecte: false,
            detention_part_indirecte_rdd: 0.0,
            parts_indirectes_indivision: 0.0,
            parts_indirectes_indivision_pleine_propriete: 0.0,
            parts_indirectes_indivision_nue_propriete: 0.0,
            parts_indirectes_personnes_morales: 0.0,
            parts_indirectes_personnes_morales_pleine_propriete: 0.0,
            parts_indirectes_personnes_morales_nue_propriete: 0.0,
            detention_part_totale: 51.0,
            detention_vote_directe: true,
            detention_vote_directe_rdd: 51.0,
            vote_directe_pleine_propriete: 51.0,
            vote_directe_nue_propriete: 0.0,
            vote_directe_usufruit: 0.0,
            detention_vote_indirecte: false,
            detention_vote_indirecte_rdd: 0.0,
            vote_indirecte_indivision: 0.0,
            vote_indirecte_indivision_pleine_propriete: 0.0,
            vote_indirecte_indivision_nue_propriete: 0.0,
            vote_indirecte_indivision_usufruit: 0.0,
            vote_indirecte_personnes_morales: 0.0,
            vote_indirecte_personnes_morales_pleine_propriete: 0.0,
            vote_indirecte_personnes_morales_nue_propriete: 0.0,
            vote_indirecte_personnes_morales_usufruit: 0.0,
            vocation_titulaire_directe_pleine_propriete_rdd: false,
            vocation_titulaire_directe_pleine_propriete: 0.0,
            vocation_titulaire_directe_nue_propriete: 0.0,
            vocation_titulaire_indirecte_indivision: 0.0,
            vocation_titulaire_indirecte_pleine_propriete_rdd: false,
            vocation_titulaire_indirecte_pleine_propriete: 0.0,
            vocation_titulaire_indirecte_nue_propriete: 0.0,
            vocation_titulaire_indirecte_personnes_morales: 0.0,
            vocation_titulaire_indirecte_personnes_morales_pleine_propriete: 0.0,
            vocation_titulaire_indirecte_personnes_morales_nue_propriete: 0.0,
            detention_vote_total: 0.0,
            detention_pouvoir_decision_ag: false,
            detention_pouvoir_nommage_membres_conseil_admin: false,
            detention_autres_moyens_controle: false,
            representant_legal: false,
            representant_legal_placement_sans_gestion_delegue: false
          }.except(*excluded_modalites)
        }
      ]
    end

    let(:valid_meta) do
      {
        count: 2
      }
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'Have limit amount of resources' do
      expect(resource_collection.count).to eq(2)
    end

    it 'has meta' do
      meta = call.bundled_data.context

      expect(meta).to eq(valid_meta)
    end

    it 'has valid resource_collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection)
    end
  end
end
