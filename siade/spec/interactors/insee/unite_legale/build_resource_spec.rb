RSpec.describe INSEE::UniteLegale::BuildResource, type: :build_resource do
  subject { organizer }

  describe 'with an unite legale response' do
    let(:organizer) { described_class.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body:) }

    let(:body) do
      INSEE::UniteLegale::MakeRequest.call(params:, token: 'valid insee token').response.body
    end

    let(:params) do
      {
        siren:
      }
    end

    context 'with a partially diffusible personne physique' do
      let(:body) { open_payload_file('insee/partially_diffusible_unite_legale_personne_physique.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siren) { is_expected.to eq('808861199') }
        its(:siret_siege_social) { is_expected.to eq('80886119900020') }
        its(:type) { is_expected.to eq(:personne_physique) }
        its(:diffusable_commercialement) { is_expected.to be(false) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }
      end
    end

    context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'insee/siren/active_GE' } do
      let(:siren) { sirens_insee_v3[:active_GE] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siret_siege_social) { is_expected.to eq("#{siren}01294") }

        its(:categorie_entreprise) { is_expected.to eq('GE') }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:diffusible) }

        its(:type) { is_expected.to eq(:personne_morale) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: 'SPORT-EXEMPLE',
            sigle: nil
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            pseudonyme: nil,
            prenom_usuel: nil,
            prenom_1: nil,
            prenom_2: nil,
            prenom_3: nil,
            prenom_4: nil,
            nom_usage: nil,
            nom_naissance: nil,
            sexe: nil
          })
        end

        its(:forme_juridique) do
          is_expected.to eq({
            code: '5599',
            libelle: 'SA à conseil d\'administration (s.a.i.)'
          })
        end

        its(:activite_principale) do
          is_expected.to eq({
            code: '46.49Y',
            libelle: "Commerce de gros d\u2019autres biens domestiques",
            nomenclature: 'NAF2025'
          })
        end

        its(:activite_principale_naf_rev2) do
          is_expected.to eq({
            code: '46.49Z',
            libelle: "Commerce de gros (commerce interentreprises) d'autres biens domestiques",
            nomenclature: 'NAFRev2'
          })
        end

        its(:tranche_effectif_salarie) do
          is_expected.to eq({
            de: 2000,
            a: 4999,
            code: '51',
            intitule: '2 000 à 4 999 salariés',
            date_reference: '2016'
          })
        end

        its(:economie_sociale_et_solidaire) { is_expected.to be_nil }

        its(:date_creation) { is_expected.to eq(Date.parse('1977-01-01').to_time.to_i) }

        its(:etat_administratif) { is_expected.to eq('A') }
        its(:date_cessation) { is_expected.to be_nil }

        its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2018-02-13').to_time.to_i) }
      end
    end

    context 'with an active AE, which is a personne physique', vcr: { cassette_name: 'insee/siren/active_AE' } do
      let(:siren) { sirens_insee_v3[:active_AE] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:type) { is_expected.to eq(:personne_physique) }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:diffusible) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: nil,
            sigle: nil
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            pseudonyme: nil,
            prenom_usuel: 'ODILE',
            prenom_1: 'ODILE',
            prenom_2: 'RENEE',
            prenom_3: 'JANINE',
            prenom_4: nil,
            nom_usage: 'BAROIN',
            nom_naissance: 'BIDAU',
            sexe: 'F'
          })
        end
      end
    end

    context 'with an active association' do
      let(:body) { open_payload_file('insee/association.json').read }
      let(:siren) { association_siren }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:rna) { is_expected.to eq('W912007752') }
      end
    end

    context 'when there is a date of 1900-01-01' do
      let(:body) do
        json = JSON.parse(read_payload_file('insee/association.json'))
        json['uniteLegale']['dateCreationUniteLegale'] = '1900-01-01'
        json.to_json
      end
      let(:siren) { association_siren }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:date_creation) { is_expected.to be_nil }
      end
    end

    context 'with a ceased company', vcr: { cassette_name: 'insee/siren/ceased' } do
      let(:siren) { sirens_insee_v3[:ceased] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:etat_administratif) { is_expected.to eq('C') }
        its(:date_cessation) { is_expected.to eq(Date.parse('2011-09-05').to_time.to_i) }
      end
    end
  end

  describe 'with an unite legale payload from an etablissement response', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:organizer) { described_class.call(response:, unite_legale:) }

    let(:response) { INSEE::Etablissement::MakeRequest.call(params:, token: 'valid insee token').response }
    let(:unite_legale) do
      JSON.parse(response.body)['etablissement']['uniteLegale']
    end

    let(:params) do
      {
        siret:
      }
    end
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }
  end
end
