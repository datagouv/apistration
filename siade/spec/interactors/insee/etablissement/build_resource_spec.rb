RSpec.describe INSEE::Etablissement::BuildResource, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    INSEE::Etablissement::MakeRequest.call(params:, token: 'valid insee token').response.body
  end

  let(:params) do
    {
      siret:
    }
  end

  context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:siege_social) { is_expected.to be(false) }
      its(:etat_administratif) { is_expected.to eq('A') }
      its(:date_fermeture) { is_expected.to be_nil }
      its(:enseigne) { is_expected.to be_nil }

      its(:activite_principale) do
        is_expected.to eq({
          code: '47.64Z',
          libelle: "Commerce de détail d'articles de sport en magasin spécialisé",
          nomenclature: 'NAFRev2'
        })
      end

      its(:adresse) { is_expected.to be_present }

      # FIXME: d'après la doc ici NN n'est pas forcément non employeuse, à creuser
      its(:tranche_effectif_salarie) do
        is_expected.to eq({
          de: nil,
          a: nil,
          code: 'NN',
          intitule: 'Unités non employeuses',
          date_reference: nil
        })
      end

      its(:diffusable_commercialement) { is_expected.to be(true) }

      its(:date_creation) { is_expected.to eq(Date.parse('2004-05-26').to_time.to_i) }

      its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2010-04-18').to_time.to_i) }
    end
  end

  context 'with a closed siret', vcr: { cassette_name: 'insee/siret/closed' } do
    let(:siret) { sirets_insee_v3[:closed] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:etat_administratif) { is_expected.to eq('F') }
      its(:date_fermeture) { is_expected.to eq(Date.parse('2011-09-05').to_time.to_i) }
    end
  end

  context 'with a closed siret without date of closing', vcr: { cassette_name: 'insee/siret/closed_without_date' } do
    let(:siret) { '78365263900015' }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:etat_administratif) { is_expected.to eq('F') }
      its(:date_fermeture) { is_expected.to be_nil }
    end
  end

  context 'with a siret which has an enseigne', vcr: { cassette_name: 'insee/siret/active_GE_ss' } do
    let(:siret) { sirets_insee_v3[:active_GE_ss] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:enseigne) { is_expected.to eq('DECATHLON DIRECTION GENERALE FRANCE') }
    end
  end

  context 'with a siret which is a personne physique (auto entrepreneur)', vcr: { cassette_name: 'insee/siret/active_AE' } do
    let(:siret) { sirets_insee_v3[:active_AE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject(:resource) { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      it 'has a valid adresse->acheminement_postal->l2, which is nomUniteLegale concatenated with prenom1UniteLegale' do
        expect(resource.adresse.acheminement_postal[:l2]).to eq('BIDAU ODILE')
      end
    end
  end
end
