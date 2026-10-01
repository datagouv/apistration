RSpec.describe Rack::Attack do
  describe 'blocked request log' do
    let(:request) do
      Rack::Attack::Request.new(
        Rack::MockRequest.env_for(
          '/v3/insee/sirene/unites_legales/123?token=secret_jwt',
          'REMOTE_ADDR' => '1.2.3.4',
          'HTTP_USER_AGENT' => 'curl',
          'rack.attack.match_type' => :throttle
        )
      )
    end

    it 'logs the path without the query string' do
      allow(Rails.logger).to receive(:error)

      ActiveSupport::Notifications.instrument('rack.attack', request:)

      expect(Rails.logger).to have_received(:error).with('BLOCKED throttle 1.2.3.4 GET /v3/insee/sirene/unites_legales/123 "curl"')
    end
  end
end
