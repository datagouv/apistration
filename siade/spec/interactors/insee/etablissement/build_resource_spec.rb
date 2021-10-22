RSpec.describe INSEE::Etablissement::BuildResource, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response: response) }
  let(:response) { instance_double('Net::HTTPOK', body: body) }

  let(:body) do
    INSEE::Etablissement::MakeRequest.call(params: params, token: 'token').response.body
  end

  let(:params) do
    {
      siret: siret
    }
  end

  context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'api_insee_fr/siret/active_GE' } do
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.resource }

      it { is_expected.to be_a(Resource) }

      its(:id) { is_expected.to eq(siret) }
      its(:siege_social) { is_expected.to eq(false) }
      its(:etat_administratif) { is_expected.to eq('A') }

      its(:activite_principale) do
        is_expected.to eq({
          code: '47.64Z',
          libelle: "Commerce de détail d'articles de sport en magasin spécialisé",
          nomenclature: 'NAFRev2'
        })
      end

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

      its(:diffusable_commercialement) { is_expected.to eq(true) }

      its(:date_creation) { is_expected.to eq(Date.parse('2004-05-26').to_time.to_i) }

      its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2010-04-18').to_time.to_i) }
    end
  end
end
