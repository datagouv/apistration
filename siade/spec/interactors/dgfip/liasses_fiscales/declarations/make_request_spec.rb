RSpec.describe DGFIP::LiassesFiscales::Declarations::MakeRequest, type: :make_request do
  subject { described_class.call(cookie:, params:) }

  let(:params) do
    {
      siren:,
      user_id:,
      year:
    }
  end
  let(:cookie) { DGFIP::Authenticate.call.cookie }

  describe 'happy path', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:siren) { valid_siren(:liasse_fiscale) }
    let(:user_id) { valid_dgfip_user_id }
    let(:year) { 2017 }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non existent siren', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    let(:user_id) { valid_dgfip_user_id }
    let(:year) { 2017 }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
