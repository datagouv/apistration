RSpec.describe ACOSS::AttestationsSociales::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:) }

  let(:siren) { valid_siren(:acoss) }
  let(:user_id) { '1' }
  let(:recipient) { '1' }
  let(:token) { 'VmZMhhLEzMsp5A3Lo52Jt-KYQBuu1NwyONm4yYwj99U' }

  let(:params) do
    {
      siren:,
      user_id:,
      recipient:
    }
  end

  it_behaves_like 'a make request with working mocking_params'

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
