RSpec.describe JwtTokenService do
  subject(:helper) { described_class.new(jwt:) }

  context 'when created with a valid jwt' do
    let(:jwt) { yes_jwt }

    its(:valid?) { is_expected.to be_truthy }
    its(:jwt_user) { is_expected.to be_a(JwtUser) }

    describe 'Jwt User' do
      subject { helper.jwt_user }

      its(:id) { is_expected.to eq('f5d5cb02-185a-426f-b3f4-99a25ce6cdf4') }
      its(:jti) { is_expected.to be_present }
    end

    describe 'non regression test: role token turns into scope token' do
      subject { helper.jwt_user }

      let(:jwt) { yes_jwt_with_roles }

      its(:scopes) { is_expected.not_to be_empty }
    end
  end

  context 'when created with an invalid jwt' do
    let(:jwt) { 'not a valid jwt token' }

    its(:valid?) { is_expected.to be_falsey }
    its(:jwt_user) { is_expected.to be_nil }
  end
end
