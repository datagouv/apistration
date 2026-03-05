RSpec.describe Token do
  describe '#to_jwt_user_attributes' do
    before do
      Timecop.freeze(Time.zone.now)
    end

    after do
      Timecop.return
    end

    let(:siret) { '23456141417862' }
    let(:uid_regexp) { /^[0-9a-f-]{36}$/ }
    let(:token) do
      described_class.create!(
        iat: 1.hour.ago.to_i,
        exp: 5.hours.from_now.to_i,
        blacklisted_at: nil,
        authorization_request_model_id: AuthorizationRequest.create!(siret:, scopes: %(open_data)).id
      )
    end
    let(:jwt_user_attributes) do
      {
        uid: match(uid_regexp),
        jti: match(uid_regexp),
        scopes: %(open_data),
        iat: 1.hour.ago.to_i,
        exp: 5.hours.from_now.to_i,
        siret:,
        blacklisted: false
      }
    end

    it 'returns a hash with the user attributes' do
      expect(token.to_jwt_user_attributes).to include(jwt_user_attributes)
    end
  end
end
