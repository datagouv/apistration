RSpec.shared_examples 'jwt policy' do |scope, action = :show?|
  subject { described_class }

  let(:jwt_user) { JwtUser.new(**payload) }
  let(:payload) do
    {
      uid: 'db398baf-80c1-4d70-a2ce-87f5a097d636',
      jti: '96b35b36-38f3-436a-99a7-20dc6a88ab4d',
      scopes: %w[scope_1 scope_2],
      iat: 1_615_460_348
    }
  end

  permissions action do
    it "authorizes a user with granted access (#{scope})" do
      payload.fetch(:scopes).push(scope.to_s)
      expect(subject).to permit(jwt_user)
    end

    it 'denies an forbidden user' do
      expect(subject).not_to permit(jwt_user)
    end
  end
end
