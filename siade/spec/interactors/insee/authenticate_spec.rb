RSpec.describe INSEE::Authenticate, type: :interactor do
  subject(:retrieve_token) { described_class.call }

  context 'when the token is not stored in redis', vcr: { cassette_name: 'insee/token' } do
    let(:token) { 'anonymized-insee-token-12345678-abcd-efgh-ijkl-9876543210fe' }
    let(:expires_in) { 598_077 }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_blank }
    its(:token) { is_expected.to eq token }

    it 'calls INSEE API' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{Siade.credentials[:insee_oauth_url]}/)
    end

    it 'stores the new token retrieved from INSEE API in cache' do
      expect {
        retrieve_token
      }.to change { EncryptedCache.read('insee/authenticate') }.to(token)
    end
  end

  context 'when the token is stored in cache' do
    let(:token) { '1234567890' }

    before do
      EncryptedCache.write('insee/authenticate', token)
    end

    it { is_expected.to be_a_success }

    it 'does not call INSEE API' do
      retrieve_token

      expect(WebMock).not_to have_requested(:post, /#{Siade.credentials[:insee_oauth_url]}/)
    end

    its(:errors) { is_expected.to be_blank }
    its(:token) { is_expected.to eq token }
  end
end
