RSpec.describe ACOSS::AttestationsSociales::MakeRequest, type: :make_request do
  subject { described_class.call(token: token, params: params) }

  let(:params) do
    {
      siren: siren,
      user_id: user_id,
      recipient: recipient,
    }
  end

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes } do
    let(:siren) { valid_siren(:acoss) }
    let(:user_id) { '1' }
    let(:recipient) { '1' }

    let(:token) { 'VmZMhhLEzMsp5A3Lo52Jt-KYQBuu1NwyONm4yYwj99U' }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
