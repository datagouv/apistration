RSpec.describe INSEE::UniteLegale::BuildResource, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response: response) }
  let(:response) { instance_double('Net::HTTPOK', body: body) }

  let(:body) do
    INSEE::UniteLegale::MakeRequest.call(params: params, token: 'token').response.body
  end

  let(:params) do
    {
      siren: siren
    }
  end

  context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'insee/siren/active_GE' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.resource }

      it { is_expected.to be_a(Resource) }

      its(:id) { is_expected.to eq(siren) }
      its(:siret_siege_social) { is_expected.to eq("#{siren}01294") }

      its(:categorie_entreprise) { is_expected.to eq('GE') }
      its(:numero_tva_intracommunautaire) { is_expected.to eq('FR51306138900') }
      its(:diffusable_commercialement) { is_expected.to eq(true) }

      its(:type) { is_expected.to eq(:personne_morale) }

      its(:personne_morale_attributs) do
        is_expected.to eq({
          raison_sociale: 'DECATHLON'
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
          code: '46.49Z',
          libelle: 'Commerce de gros (commerce interentreprises) d\'autres biens domestiques',
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

      its(:date_creation) { is_expected.to eq(Date.parse('1977-01-01').to_time.to_i) }

      its(:etat_administratif) { is_expected.to eq('A') }
      its(:date_cessation) { is_expected.to eq(nil) }

      its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2018-02-13').to_time.to_i) }
    end
  end

  context 'with an active AE, which is a personne physique', vcr: { cassette_name: 'insee/siren/active_AE' } do
    let(:siren) { sirens_insee_v3[:active_AE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.resource }

      it { is_expected.to be_a(Resource) }

      its(:type) { is_expected.to eq(:personne_physique) }

      its(:personne_morale_attributs) do
        is_expected.to eq({
          raison_sociale: nil
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

  context 'with a ceased company', vcr: { cassette_name: 'insee/siren/ceased' } do
    let(:siren) { sirens_insee_v3[:ceased] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.resource }

      it { is_expected.to be_a(Resource) }

      its(:etat_administratif) { is_expected.to eq('C') }
      its(:date_cessation) { is_expected.to eq(Date.parse('2011-09-05').to_time.to_i) }
    end
  end
end
