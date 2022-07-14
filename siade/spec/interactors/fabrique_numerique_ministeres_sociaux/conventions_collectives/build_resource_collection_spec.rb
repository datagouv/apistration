RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::BuildResourceCollection, type: :build_resource do
  subject(:call) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siret:
    }
  end

  let(:resource_collection) { call.bundled_data.data }

  context 'when siret is valid', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
    let(:siret) { valid_siret(:conventions_collectives) }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'builds valid resource items' do
      expect(resource_collection.first.to_h).to eq(
        {
          id: 'KALICONT000005635173',
          numero_idcc: 1486,
          titre: 'Convention collective nationale des bureaux d\'études techniques, des cabinets d\'ingénieurs-conseils et des sociétés de conseils du 15 décembre 1987.',
          titre_court: 'Bureaux d\'études techniques, cabinets d\'ingénieurs-conseils et sociétés de conseils',
          active: true,
          etat: 'vigueur_etendue',
          url: 'https://www.legifrance.gouv.fr/affichIDCC.do?idConvention=KALICONT000005635173',
          synonymes: ['syntec'],
          date_publication: '1988-01-01'
        }
      )
    end
  end
end
