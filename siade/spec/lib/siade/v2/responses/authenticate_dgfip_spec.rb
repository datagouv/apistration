RSpec.describe SIADE::V2::Responses::AuthenticateDGFIP, type: :provider_response do
  subject { SIADE::V2::Requests::AuthenticateDGFIP.new.perform.response }

  context 'when authentication succeed', vcr: { cassette_name: 'authenticate_dgfip_service_with_valid_secret' } do
    its(:cookie)    { is_expected.not_to be_empty }
    its(:errors)    { is_expected.to be_empty }
    its(:http_code) { is_expected.to eq(200) }
  end

  context 'when authentication failed', vcr: { cassette_name: 'authenticate_dgfip_service_with_wrong_secret' } do
    before do
      allow_any_instance_of(SIADE::V2::Requests::AuthenticateDGFIP).to receive(:secret).and_return('wrong_secret')
    end

    its(:cookie)    { is_expected.to include("_test_client") }
    its(:errors)    { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGFIP' a échoué") }
    its(:http_code) { is_expected.to eq(502) }
  end
end
