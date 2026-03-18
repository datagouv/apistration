RSpec.describe SIADE::V2::Drivers::ConventionsCollectives, type: :provider_driver do
  context 'when siret is not found', vcr: { cassette_name: 'conventions_collectives_with_not_found_siret' } do
    let(:siret) { not_found_siret(:conventions_collectives) }
    subject { described_class.new(siret: siret).perform_request }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when siret is found', vcr: { cassette_name: 'conventions_collectives_with_valid_siret' } do
    before do
      remember_through_each_test_of_current_scope('conventions_collectives') do
        described_class.new(siret: valid_siret(:conventions_collectives))
      end
    end

    subject { @conventions_collectives.perform_request }

    its(:conventions) do
      is_expected.to match([{
        active:           true,
        date_publication: '1988-01-01T00:00:00.000Z',
        etat:             'VIGUEUR_ETEN',
        numero:           1486,
        titre_court:      'Bureaux d\'études techniques, cabinets d\'ingénieurs-conseils et sociétés de conseils',
        titre:            'Convention collective nationale des bureaux d\'études techniques, des cabinets d\'ingénieurs-conseils et des sociétés de conseils du 15 décembre 1987. ',
        url:              'https://www.legifrance.gouv.fr/affichIDCC.do?idConvention=KALICONT000005635173'
      }])
    end
  end
end
