RSpec.describe RateLimitHeadersMiddleware, type: :middleware do
  subject { described_class.new(app).call(env) }

  let(:app) { ->(env) { [200, env, '{}'] } }

  let(:throttle_data) do
    {
      discriminator: '1234567890',
      count: 1,
      limit: 2,
      period: 60,
      epoch_time: Time.now.to_i
    }
  end
  let(:rate_limit_subkeys) do
    %w[
      Limit
      Remaining
      Reset
    ]
  end

  before do
    allow(MonitoringService.instance).to receive(:track_with_added_context)
  end

  describe 'when there is only one throttle defined' do
    let(:env) do
      {
        'rack.attack.throttle_data' => {
          'high_latency_documents' => throttle_data
        }
      }
    end

    it 'adds RateLimit headers' do
      _status, headers, _body = subject

      rate_limit_subkeys.each do |subkey|
        expect(headers).to have_key("RateLimit-#{subkey}")
      end
    end

    it 'does not log through monitoring service' do
      subject

      expect(MonitoringService.instance).not_to have_received(:track_with_added_context)
    end
  end

  describe 'when custom_rate_limit is present alongside another throttle' do
    let(:custom_throttle_data) do
      {
        discriminator: '1234567890',
        count: 3,
        limit: 10,
        period: 60,
        epoch_time: Time.now.to_i
      }
    end

    let(:env) do
      {
        'rack.attack.throttle_data' => {
          'json_resources_entreprise' => throttle_data,
          'custom_rate_limit' => custom_throttle_data
        }
      }
    end

    it 'adds RateLimit headers based on custom_rate_limit data' do
      _status, headers, _body = subject

      rate_limit_subkeys.each do |subkey|
        expect(headers).to have_key("RateLimit-#{subkey}")
      end

      expect(headers['RateLimit-Limit']).to eq('10')
    end

    it 'does not log through monitoring service' do
      subject

      expect(MonitoringService.instance).not_to have_received(:track_with_added_context)
    end
  end

  describe 'when there is multiple throttle defined' do
    let(:env) do
      {
        'rack.attack.throttle_data' => {
          'low_latency_docs' => throttle_data,
          'high_latency_documents' => throttle_data
        }
      }
    end

    it 'does not add RateLimit headers' do
      _status, headers, _body = subject

      rate_limit_subkeys.each do |subkey|
        expect(headers).not_to have_key("RateLimit-#{subkey}")
      end
    end

    it 'logs through monitoring service' do
      subject

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'warning',
        'Multiple throttle data detected (Rack::Attack misconfiguration)',
        env['rack.attack.throttle_data']
      )
    end
  end
end
