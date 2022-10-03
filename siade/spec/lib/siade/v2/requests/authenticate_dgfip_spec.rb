RSpec.describe SIADE::V2::Requests::AuthenticateDGFIP, type: :provider_request do
  subject { described_class.new.perform }

  context 'when authentication fail', vcr: { cassette_name: 'dgfip/authenticate/wrong_secret' } do
    before { allow_any_instance_of(SIADE::V2::Requests::AuthenticateDGFIP).to receive(:secret).and_return('wrong_secret') }

    its(:http_code) { is_expected.to eq(502) }
    its(:errors)    { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGFIP - Adélie' a échoué") }
  end

  context 'good request', vcr: { cassette_name: 'dgfip/authenticate/valid' } do
    its(:http_code) { is_expected.to eq(200) }
    its(:errors)    { is_expected.to be_empty }
    its(:cookie)    { is_expected.not_to be_empty }
  end
end
