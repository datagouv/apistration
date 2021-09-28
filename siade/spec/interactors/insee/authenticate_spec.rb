RSpec.describe INSEE::Authenticate, type: :interactor do
  subject(:retrieve_token) { described_class.call }

  context 'when the token is not stored in redis', vcr: { cassette_name: 'insee/token' } do
    let(:token) { '34ca8c63-891b-3479-86be-2c40f66497a2' }
    let(:expires_in) { 598_077 }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_blank }
    its(:token) { is_expected.to eq token }

    it 'calls INSEE API' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{Siade.credentials[:insee_v3_domain]}/)
    end

    it 'stores the new token retrieved from INSEE API in redis' do
      expect {
        retrieve_token
      }.to change { Redis.current.get('insee_token') }.to(token)
    end

    it 'sets a expires_in value as ttl for this redis key' do
      expect {
        retrieve_token
      }.to change { Redis.current.ttl('insee_token') }.to(expires_in)
    end
  end

  context 'when the token is stored in redis' do
    let(:token) { '1234567890' }

    before do
      Redis.current.set('insee_token', token)
    end

    it { is_expected.to be_a_success }

    it 'does not call INSEE API' do
      retrieve_token

      expect(WebMock).not_to have_requested(:post, /#{Siade.credentials[:insee_v3_domain]}/)
    end

    its(:errors) { is_expected.to be_blank }
    its(:token) { is_expected.to eq token }
  end
end
