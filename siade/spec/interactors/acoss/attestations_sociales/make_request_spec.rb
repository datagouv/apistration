RSpec.describe ACOSS::AttestationsSociales::MakeRequest, type: :make_request do
  subject { described_class.call(token: token, params: params) }

  let(:params) do
    {
      siren: siren,
      user_id: user_id,
      recipient: recipient,
    }
  end

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    let(:siren) { valid_siren(:acoss) }
    let(:user_id) { 'user id' }
    let(:recipient) { 'SIRET of someone' }

    let(:token) { 'VmZMhhLEzMsp5A3Lo52Jt-KYQBuu1NwyONm4yYwj99U' }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
