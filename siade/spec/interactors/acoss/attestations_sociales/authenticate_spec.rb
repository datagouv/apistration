RSpec.describe ACOSS::AttestationsSociales::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when acoss authentication succeed', vcr: { cassette_name: 'acoss/oauth2', match_requests_on: [:method, :uri, :body] } do
    let(:access_token_from_vcr_acoss) { 'jJIHl8_MiMJ0fjF_-rGolr6mLRrG_WXy1RoIRGYHiGg' }

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to eq(access_token_from_vcr_acoss)
    end
  end
end
