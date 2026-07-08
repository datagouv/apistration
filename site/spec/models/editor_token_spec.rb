RSpec.describe EditorToken do
  it 'has a valid factory' do
    expect(build(:editor_token)).to be_valid
  end

  describe '#rehash' do
    subject { editor_token.rehash }

    let(:editor_token) { create(:editor_token) }

    it 'returns a JWT string' do
      expect(subject).to be_a(String)
    end

    it 'contains editor: true in payload' do
      payload = AccessToken.decode(subject)

      expect(payload[:editor]).to be true
    end

    it 'contains expected fields' do
      payload = AccessToken.decode(subject)

      expect(payload[:uid]).to eq(editor_token.id)
      expect(payload[:jti]).to eq(editor_token.id)
      expect(payload[:sub]).to eq(editor_token.editor.name)
      expect(payload[:version]).to eq('1.0')
      expect(payload[:iat]).to eq(editor_token.iat)
      expect(payload[:exp]).to eq(editor_token.exp)
    end

    it 'contains empty scopes (resolved dynamically via delegation)' do
      payload = AccessToken.decode(editor_token.rehash)

      expect(payload[:scopes]).to eq([])
    end
  end

  describe '#allowed_ips' do
    it 'is optional' do
      expect(build(:editor_token, allowed_ips: [])).to be_valid
    end

    it 'stores exact IPs as /32 entries' do
      editor_token = create(:editor_token, allowed_ips: ['203.0.113.10'])

      expect(editor_token.reload.allowed_ips).to eq([IPAddr.new('203.0.113.10/32')])
    end

    it 'accepts up to 10 CIDR ranges' do
      editor_token = build(:editor_token, allowed_ips: ['203.0.113.0/24', '198.51.100.42'])

      expect(editor_token).to be_valid
    end

    it 'rejects private ranges' do
      editor_token = build(:editor_token, allowed_ips: ['10.0.0.1'])

      expect(editor_token).not_to be_valid
      expect(editor_token.errors[:allowed_ips]).to be_present
    end

    it 'rejects malformed entries' do
      editor_token = build(:editor_token, allowed_ips: ['wat'])

      expect(editor_token).not_to be_valid
    end
  end

  describe '#expired?' do
    it 'returns true when exp is in the past' do
      editor_token = build(:editor_token, :expired)

      expect(editor_token).to be_expired
    end

    it 'returns false when exp is in the future' do
      editor_token = build(:editor_token)

      expect(editor_token).not_to be_expired
    end
  end

  describe '#blacklisted?' do
    it 'returns true when blacklisted_at is in the past' do
      editor_token = build(:editor_token, :blacklisted)

      expect(editor_token).to be_blacklisted
    end

    it 'returns false when blacklisted_at is nil' do
      editor_token = build(:editor_token)

      expect(editor_token).not_to be_blacklisted
    end

    it 'returns false when blacklisted_at is in the future' do
      editor_token = build(:editor_token, blacklisted_at: 1.month.from_now)

      expect(editor_token).not_to be_blacklisted
    end
  end

  describe '#active?' do
    it 'returns true when not expired and not blacklisted' do
      editor_token = build(:editor_token)

      expect(editor_token).to be_active
    end

    it 'returns false when expired' do
      editor_token = build(:editor_token, :expired)

      expect(editor_token).not_to be_active
    end

    it 'returns false when blacklisted' do
      editor_token = build(:editor_token, :blacklisted)

      expect(editor_token).not_to be_active
    end
  end

  describe '.active' do
    let!(:active_token) { create(:editor_token) }
    let!(:expired_token) { create(:editor_token, :expired) }
    let!(:blacklisted_token) { create(:editor_token, :blacklisted) }

    it 'returns only active tokens' do
      expect(described_class.active).to contain_exactly(active_token)
    end
  end
end
