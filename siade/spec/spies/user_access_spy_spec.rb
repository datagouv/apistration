RSpec.describe UserAccessSpy do
  let(:user) { JwtUser.new(uid: 'user unique identifier', roles: ['role 1', 'role 2'], jti: 'jwt token unique identifier', iat: 1_615_460_348) }

  it 'logs authorized' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('user_access', user: user.logstash_id, jti: user.token_id, iat: Time.zone.at(user.iat), access: 'allow')
    described_class.log_authorized(user:)
  end

  it 'logs forbidden jwt token' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('user_access', user: user.logstash_id, jti: user.token_id, access: 'deny')
    described_class.log_forbidden_jwt_token(user:)
  end

  it 'logs unauthorized' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('user_access', user: 'user_info', jti: nil, access: 'deny')
    described_class.log_unauthorized(user_info: 'user_info')
  end

  it 'logs not acceptable' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('user_access', user: nil, jti: nil, access: 'not acceptable context')
    described_class.log_not_acceptable
  end
end
