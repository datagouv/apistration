RSpec.describe API::V2::ConventionsCollectivesController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'with valid token and mandatory parameters' do
    let(:token) { yes_jwt }

    subject { get :show, params: { siret: siret, token: token }.merge(mandatory_params) }

    context 'when siret is not found', vcr: { cassette_name: 'conventions_collectives_with_not_found_siret' } do
      let(:siret) { not_found_siret(:conventions_collectives) }

      its(:status) { is_expected.to eq(404) }

      it 'returns an error message' do
        subject

        expect(response_json).to have_json_error(
          detail: 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel',
        )
      end
    end

    context 'when siret is valid', vcr: { cassette_name: 'conventions_collectives_with_valid_siret' } do
      let(:siret) { valid_siret(:conventions_collectives) }

      its(:status) { is_expected.to eq(200) }

      it 'returns the JSON payload' do
        subject

        expect(response_json).to match({
          siret:       siret,
          conventions: [{
            active:           true,
            date_publication: '1988-01-01T00:00:00.000Z',
            etat:             'VIGUEUR_ETEN',
            numero:           1486,
            titre_court:      'Bureaux d\'études techniques, cabinets d\'ingénieurs-conseils et sociétés de conseils',
            titre:            'Convention collective nationale des bureaux d\'études techniques, des cabinets d\'ingénieurs-conseils et des sociétés de conseils du 15 décembre 1987. ',
            url:              'https://www.legifrance.gouv.fr/affichIDCC.do?idConvention=KALICONT000005635173'
          }]
        })
      end
    end
  end
end
