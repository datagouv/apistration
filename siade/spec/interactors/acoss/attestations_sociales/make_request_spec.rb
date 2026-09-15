RSpec.describe ACOSS::AttestationsSociales::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:, recipient:) }

  let(:siren) { valid_siren(:acoss) }
  let(:user_id) { '1' }
  let(:recipient) { '78951073200017' }
  let(:token) { 'VmZMhhLEzMsp5A3Lo52Jt-KYQBuu1NwyONm4yYwj99U' }

  let(:params) do
    {
      siren:,
      user_id:
    }
  end

  it_behaves_like 'a make request with working mocking_params'

  describe 'happy path' do
    before do
      mock_valid_urssaf_attestation_sociale(token) do
        Base64.strict_encode64(Rails.root.join('spec/fixtures/pdfs/urssaf_attestations_sociales/basic.pdf').read)
      end
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
