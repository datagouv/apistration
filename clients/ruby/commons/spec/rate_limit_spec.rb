RSpec.describe ApiGouvCommons::RateLimit do
  it 'parses well-formed RateLimit-* headers' do
    rl = described_class.from_headers(
      'RateLimit-Limit' => '50',
      'RateLimit-Remaining' => '47',
      'RateLimit-Reset' => '1637223155'
    )
    expect(rl.limit).to eq(50)
    expect(rl.remaining).to eq(47)
    expect(rl.reset_at).to eq(Time.at(1_637_223_155).utc)
  end

  it 'handles lowercase headers (Faraday normalised)' do
    rl = described_class.from_headers('ratelimit-limit' => '50', 'ratelimit-remaining' => '49', 'ratelimit-reset' => '1700000000')
    expect(rl.remaining).to eq(49)
  end

  it 'returns nil when no rate-limit headers are present' do
    expect(described_class.from_headers('content-type' => 'application/json')).to be_nil
  end

  it 'returns nil for malformed values rather than raising' do
    rl = described_class.from_headers(
      'RateLimit-Limit' => 'not-a-number',
      'RateLimit-Remaining' => 'oops',
      'RateLimit-Reset' => 'NaN'
    )
    expect(rl).to be_nil
  end

  describe '#retry_after' do
    it 'returns seconds remaining when reset_at is in the future' do
      now = Time.now
      rl = described_class.new(limit: 50, remaining: 0, reset_at: now + 30)
      expect(rl.retry_after(now: now)).to eq(30)
    end

    it 'clamps to zero when reset_at is in the past' do
      now = Time.now
      rl = described_class.new(limit: 50, remaining: 0, reset_at: now - 30)
      expect(rl.retry_after(now: now)).to eq(0)
    end

    it 'returns nil if reset_at is nil' do
      rl = described_class.new(limit: 50, remaining: 10, reset_at: nil)
      expect(rl.retry_after).to be_nil
    end
  end
end
