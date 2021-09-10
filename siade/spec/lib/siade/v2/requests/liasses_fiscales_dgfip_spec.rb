RSpec.describe SIADE::V2::Requests::LiassesFiscalesDGFIP, type: :provider_request do
  subject do
    described_class.new(
      {
        siren: siren,
        annee: year,
        cookie: cookie,
        user_id: user_id,
        request_name: request_name
      }
    ).perform
  end

  let(:siren)   { valid_siren(:liasse_fiscale) }
  let(:year)    { 2017 }
  let(:cookie)  { valid_dgfip_cookie }
  let(:user_id) { valid_dgfip_user_id }

  let(:request_name) { :declaration }

  describe 'params are well formatted' do
    context 'with a non existent siren', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_non_existent_siren' } do
      let(:siren) { non_existent_siren }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
    end

    context 'with a closed siren', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_ceased_siren' } do
      let(:siren) { ceased_siren }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
    end

    context 'with a valid siren liasse fiscale', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_valid_siren' } do
      let(:request_name) { :declaration }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }
      its(:response) { is_expected.to be_a_kind_of(SIADE::V2::Responses::LiassesFiscalesDGFIP) }

      it 'has a correct response body' do
        expect(JSON.parse(subject.response.body)).to match_json_schema('liasse_fiscale_declaration')
      end
    end

    context 'with a valid siren dictionary', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_valid_siren' } do
      let(:request_name) { :dictionary }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }
      its(:response) { is_expected.to be_a_kind_of(SIADE::V2::Responses::LiassesFiscalesDGFIP) }

      it 'has a correct response body' do
        expect(JSON.parse(subject.response.body)).to match_json_schema('liasse_fiscale_dictionary')
      end
    end

    context 'without siren dictionary', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_valid_siren' } do
      subject do
        described_class.new(
          {
            annee: year,
            cookie: cookie,
            user_id: user_id,
            request_name: request_name
          }
        ).perform
      end

      let(:request_name) { :dictionary }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }
      its(:response) { is_expected.to be_a_kind_of(SIADE::V2::Responses::LiassesFiscalesDGFIP) }

      it 'has a correct response body' do
        expect(JSON.parse(subject.response.body)).to match_json_schema('liasse_fiscale_dictionary')
      end
    end
  end

  describe 'one param is not well formatted' do
    context 'with invalid siren' do
      let(:siren) { invalid_siren }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
    end

    context 'with invalid year' do
      let(:year) { 'not an integer' }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error('L\'année n\'est pas correctement formatée') }
    end

    context 'with invalid user_id' do
      let(:user_id) { 'invalid@user_id' }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error('Le user_id n\'est pas correctement formaté') }
    end

    context 'with invalid cookie' do
      let(:cookie) { 'invalid_cookie' }

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGFIP' a échoué") }
    end
  end
end
