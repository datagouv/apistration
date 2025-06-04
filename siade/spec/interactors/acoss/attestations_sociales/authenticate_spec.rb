RSpec.describe ACOSS::AttestationsSociales::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when acoss authentication succeed', vcr: { cassette_name: 'acoss/oauth2' } do
    let(:access_token_from_vcr_acoss) { 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJhY29zcy1hcGkiLCJzdWIiOiJhcGktZXF1aXZhbGVuY2UiLCJhdWQiOiJhcGktZW50cmVwcmlzZSIsImV4cCI6MTY0MjAwMDAwMCwiaWF0IjoxNjQxOTk2NDAwfQ.fake_signature_for_anonymized_token' }

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to eq(access_token_from_vcr_acoss)
    end
  end
end
