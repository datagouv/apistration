RSpec.describe SIADE::V2::Retrievers::LiassesFiscalesDGFIP do
  subject { described_class.new(params).retrieve }

  let(:cookie_from_dgfip) { valid_dgfip_cookie }

  let(:params) do
    {
      siren: siren,
      annee: 2017,
      cookie: cookie_from_dgfip,
      user_id: valid_dgfip_user_id,
      request_type: request_type
    }
  end

  describe 'when asking only for the declaration', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:siren) { valid_siren(:liasse_fiscale) }
    let(:request_type) { :declaration }

    its(:http_code) { is_expected.to eq(200) }
    its(:response) { is_expected.to match_json_schema('liasse_fiscale_declaration') }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'when asking only for the dictionary', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:siren) { valid_siren(:liasse_fiscale) }
    let(:request_type) { :dictionary }

    its(:http_code) { is_expected.to eq(200) }
    its(:response) { is_expected.to match_json_schema('liasse_fiscale_dictionary') }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'when asking for the declaration & the dictionary', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:siren) { valid_siren(:liasse_fiscale) }
    let(:request_type) { :both }

    its(:http_code) { is_expected.to eq(200) }
    its(:response) { is_expected.to match_json_schema('liasse_fiscale_complete') }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'when asking declaration with a non existent siren', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_non_existent_siren' } do
    let(:siren) { non_existent_siren }
    let(:request_type) { :declaration }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  describe 'when asking dictionary with a non existent siren', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_non_existent_siren' } do
    let(:siren) { non_existent_siren }
    let(:request_type) { :dictionary }

    its(:http_code) { is_expected.to eq(200) }
    its(:response) { is_expected.to match_json_schema('liasse_fiscale_dictionary') }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'when asking only for the dictionary without siren', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:params) do
      {
        annee: 2017,
        cookie: cookie_from_dgfip,
        user_id: valid_dgfip_user_id,
        request_type: request_type
      }
    end

    let(:request_type) { :dictionary }

    its(:http_code) { is_expected.to eq(200) }
    its(:response) { is_expected.to match_json_schema('liasse_fiscale_dictionary') }
    its(:errors) { is_expected.to be_empty }
  end
end
