RSpec.describe AuthenticateDGFIPService do
  subject { described_class.new.authenticate! }

  context 'authentication fails', vcr: { cassette_name: 'dgfip/authenticate/wrong_secret' } do
    before do
      allow_any_instance_of(SIADE::V2::Requests::AuthenticateDGFIP).to receive(:secret).and_return('wrong_secret')
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:success?) { is_expected.to be_falsey }
    its(:errors) { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGFIP - Adélie' a échoué") }
  end

  describe 'authentication succeeds', vcr: { cassette_name: 'dgfip/authenticate/valid' } do
    its(:http_code) { is_expected.to eq(200) }
    its(:success?)  { is_expected.to be_truthy }
    its(:errors)    { is_expected.to be_empty }
    its(:cookie)    { is_expected.to match('^lemondgfip=.{65}; domain=.dgfip.finances.gouv.fr; path=\/') }
  end
end
