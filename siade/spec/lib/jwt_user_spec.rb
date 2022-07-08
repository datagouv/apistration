RSpec.describe JwtUser do
  let(:jwt_payload) do
    {
      uid: 'db398baf-80c1-4d70-a2ce-87f5a097d636',
      jti: '96b35b36-38f3-436a-99a7-20dc6a88ab4d',
      scopes: %w[scope_1 scope_2],
      iat: 1_615_460_348
    }
  end

  describe '#initialize' do
    it 'requires a uid keyword' do
      jwt_payload.delete(:uid)

      expect { described_class.new(**jwt_payload) }
        .to raise_error ArgumentError
    end

    it 'requires a scopes keyword' do
      jwt_payload.delete(:scopes)

      expect { described_class.new(**jwt_payload) }
        .to raise_error ArgumentError
    end

    it 'requires a jti keyword' do
      jwt_payload.delete(:jti)

      expect { described_class.new(**jwt_payload) }
        .to raise_error ArgumentError
    end

    it 'requires an iat (issued at)' do
      jwt_payload.delete(:iat)

      expect { described_class.new(**jwt_payload) }
        .to raise_error ArgumentError
    end
  end

  describe '#has_access?' do
    let(:jwt_user) { described_class.new(**jwt_payload) }

    it 'returns true when given scope is in the list' do
      expect(jwt_user.has_access?('scope_1')).to be true
    end

    it 'returns false when given scope is not in the list' do
      expect(jwt_user.has_access?('scope_4')).to be false
    end
  end

  describe '#scopes' do
    let(:jwt_user) { described_class.new(**jwt_payload) }

    it 'returns its scopes' do
      expect(jwt_user.scopes).to eq(%w[scope_1 scope_2])
    end
  end

  describe 'respond to ?' do
    let(:jwt_user) { described_class.new(**jwt_payload) }

    it 'responds to logstash_id' do
      expect(jwt_user).to respond_to(:logstash_id)
    end

    it 'responds to token_id' do
      expect(jwt_user).to respond_to(:token_id)
    end

    it 'responds to jti' do
      expect(jwt_user).to respond_to(:jti)
    end

    it 'responds to scopes' do
      expect(jwt_user).to respond_to(:scopes)
    end
  end
end
