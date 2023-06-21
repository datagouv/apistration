RSpec.describe JwtTokenService do
  describe '#extract_user' do
    subject(:extract_user) { described_class.new(jwt).extract_user }

    describe 'with a valid jwt' do
      let(:jwt) { yes_jwt }

      it { is_expected.to be_a(JwtUser) }

      its(:id) { is_expected.to eq('f5d5cb02-185a-426f-b3f4-99a25ce6cdf4') }
      its(:jti) { is_expected.to be_present }
      its(:scopes) { is_expected.to be_present }
    end

    context 'with an invalid jwt' do
      let(:jwt) { 'not a valid jwt token' }

      it { is_expected.to be_nil }
    end
  end
end
