RSpec.describe Rack::Attack do
  describe 'blocked request security event' do
    let(:request) do
      Rack::Attack::Request.new(
        Rack::MockRequest.env_for(
          '/v3/insee/sirene/unites_legales/123?token=secret_jwt',
          'REMOTE_ADDR' => '1.2.3.4',
          'HTTP_USER_AGENT' => 'curl',
          'rack.attack.match_type' => :throttle,
          'rack.attack.matched' => 'insee/unites_legales'
        )
      )
    end

    it 'emits a throttled request with the path without its query string' do
      expect { ActiveSupport::Notifications.instrument('rack.attack', request:) }.to emit_security_event('api.request.blocked').with(
        actor: { email: nil, role: 'api_client' },
        target: { type: 'token', id: nil },
        details: {
          reason: 'throttled',
          rule: 'insee/unites_legales',
          ip: '1.2.3.4',
          method: 'GET',
          path: '/v3/insee/sirene/unites_legales/123',
          user_agent: 'curl'
        }
      )
    end

    it 'filters the attestation token carried in the path of a throttled download' do
      attestation_request = Rack::Attack::Request.new(
        Rack::MockRequest.env_for('/api/attestations/reusable-secret', 'rack.attack.match_type' => :throttle, 'rack.attack.matched' => 'attestations per IP')
      )

      expect { ActiveSupport::Notifications.instrument('rack.attack', request: attestation_request) }.to emit_security_event('api.request.blocked').with(
        details: hash_including(path: '/api/attestations/[FILTERED]')
      )
    end

    it 'filters the credential of a proxied file even behind repeated slashes' do
      proxied_file_request = Rack::Attack::Request.new(
        Rack::MockRequest.env_for('/proxy//files//reusable-uuid', 'rack.attack.match_type' => :throttle, 'rack.attack.matched' => 'proxy')
      )

      expect { ActiveSupport::Notifications.instrument('rack.attack', request: proxied_file_request) }.to emit_security_event('api.request.blocked').with(
        details: hash_including(path: '/proxy/files/[FILTERED]')
      )
    end

    it 'emits nothing for a safelisted request' do
      request.env['rack.attack.match_type'] = :safelist

      expect { ActiveSupport::Notifications.instrument('rack.attack', request:) }.not_to emit_security_event('api.request.blocked')
    end
  end
end
