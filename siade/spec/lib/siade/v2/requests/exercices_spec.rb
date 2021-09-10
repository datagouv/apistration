RSpec.describe SIADE::V2::Requests::Exercices, type: :provider_request do
  subject { described_class.new(siret, options).perform }

  let(:options) do
    {
      cookie: 'lemondgfip=337804d37291c5ab43a5419f67a542af_047e83a53cca805e6a773d6be8ae4dbb; domain=.dgfip.finances.gouv.fr; path=/',
      user_id: valid_dgfip_user_id
    }
  end

  context 'bad formated request' do
    let(:siret) { invalid_siret }

    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'well formated request', vcr: { cassette_name: 'exercice_with_valid_siret' } do
    let(:siret) { valid_siret(:exercice) }

    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { is_expected.to be_empty }
  end

  context 'when DGFIP respond with a 302 Found', vcr: { cassette_name: 'exercice_with_redirect_siret' } do
    let(:siret) { out_of_scope_dgfip }

    context 'when the new URI is identical' do
      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error('Erreur de la DGFIP, celle intervient généralement lorsque l\'organisme n\'est pas soumis à l\'impôt sur les sociétés. Si c\'est bien le cas il est possible que les comptes n\'est pas encore été déposés aux greffes.') }
      its(:response) { is_expected.to be_a(SIADE::V2::Responses::Exercices) }
    end

    context 'when the new URI is different' do
      before do
        # Manually built an expected new location with a different siret
        mocked_new_location_url = "#{Siade.credentials[:dgfip_authenticate_url]}?op=c&url=#{Base64.urlsafe_encode64("#{Siade.credentials[:dgfip_chiffres_affaires_url]}?userId=tech_at_apientreprise.fr.dev_user_id&siret=50278496000042")}"

        url = Siade.credentials[:dgfip_chiffres_affaires_url]
        stub_request(:get, /#{url}/).with(headers: { 'Cookie' => options[:cookie] }).to_return(
          status: 302,
          body: 'whatever',
          headers: {
            'Location' => mocked_new_location_url
          }
        )
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:response) { is_expected.to be_a(SIADE::V2::Responses::UnexpectedRedirection) }
    end
  end
end
