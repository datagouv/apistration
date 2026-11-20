require 'rails_helper'

RSpec.describe 'Health checks' do
  before { host! '10.0.0.12' }

  describe 'GET /healthz' do
    it 'answers the kubelet as long as the app runs, even when the database is unreachable' do
      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_raise(ActiveRecord::ConnectionNotEstablished)

      get '/healthz'

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq('status' => 'up')
    end

    it 'is not served on the public domain' do
      host! 'entreprise.api.localtest.me'

      expect { get '/healthz' }.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET /healthz/database' do
    it 'is up when the database answers' do
      get '/healthz/database'

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq('status' => 'up')
    end

    it 'answers the kubelet on an IPv6 pod address with its port' do
      get '/healthz/database', env: { 'HTTP_HOST' => '[fd00::12]:3000' }

      expect(response).to have_http_status(:ok)
    end

    it 'is not served to a request relayed by the public proxy, even with a forged forwarded host' do
      host! 'entreprise.api.localtest.me'

      expect { get '/healthz/database', headers: { 'X-Forwarded-Host' => '10.0.0.12', 'X-Forwarded-For' => '203.0.113.4' } }.to raise_error(ActionController::RoutingError)
    end

    it 'is not served to a request relayed by a proxy that rewrites the host to the pod IP' do
      expect { get '/healthz/database', headers: { 'X-Forwarded-For' => '203.0.113.4' } }.to raise_error(ActionController::RoutingError)
    end

    it 'is down when the database is unreachable, and logs why without exposing it' do
      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_raise(ActiveRecord::ConnectionNotEstablished, 'connection to server at "10.0.0.5" failed')
      allow(Rails.logger).to receive(:error)

      get '/healthz/database'

      expect(response).to have_http_status(:service_unavailable)
      expect(response.parsed_body).to eq('status' => 'down')
      expect(Rails.logger).to have_received(:error).with(/ActiveRecord::ConnectionNotEstablished: connection to server at "10.0.0.5" failed/)
    end

    it 'is not served on the public domain' do
      host! 'entreprise.api.localtest.me'

      expect { get '/healthz/database' }.to raise_error(ActionController::RoutingError)
    end
  end

end
