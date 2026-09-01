require 'rails_helper'

RSpec.describe ProviderResponseDebuggingService do
  subject(:service) { described_class.new(user, request) }

  let(:user) { instance_double(JwtUser, token_id: whitelisted_token_id) }
  let(:whitelisted_token_id) { 'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4' }
  let(:request) { instance_double(ActionDispatch::Request, headers:) }
  let(:headers) { { described_class::HEADER_NAME => 'true' } }

  before do
    Siade.credentials[described_class::CREDENTIALS_KEY] = [whitelisted_token_id]
  end

  after do
    Siade.credentials.delete(described_class::CREDENTIALS_KEY)
  end

  context 'when the header is present and the token is whitelisted' do
    it { expect(service).to be_enable }
  end

  context 'when the header is missing' do
    let(:headers) { {} }

    it { expect(service).not_to be_enable }
  end

  context 'when the token is not whitelisted' do
    let(:user) { instance_double(JwtUser, token_id: '00000000-0000-0000-0000-000000000000') }

    it { expect(service).not_to be_enable }
  end

  context 'when there is no user' do
    let(:user) { nil }

    it { expect(service).not_to be_enable }
  end

  context 'when no token is whitelisted' do
    before do
      Siade.credentials.delete(described_class::CREDENTIALS_KEY)
    end

    it { expect(service).not_to be_enable }
  end
end
