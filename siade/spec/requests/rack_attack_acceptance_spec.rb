RSpec.describe 'Rack::Attack acceptance' do
  describe 'all throttled endpoints' do
    let(:all_routes) do
      Rails.application.routes.routes.each_with_object([]) do |route, res|
        next if route.defaults == {}
        next if route.defaults[:controller] =~ %r{api_particulier/v2/}

        route_conf = {
          controller: route.defaults[:controller],
          action: route.defaults[:action]
        }
        res.push(route_conf) unless non_throttled_endpoints.include?(route_conf)
      end
    end

    let(:non_throttled_endpoints) do
      [
        {
          controller: 'api_entreprise/privileges',
          action: 'show'
        },
        {
          controller: 'ping',
          action: 'show'
        },
        {
          controller: 'errors',
          action: 'not_found'
        },
        {
          controller: 'errors',
          action: 'gone'
        },
        {
          controller: 'reload_mock_backend',
          action: 'create'
        },
        {
          controller: 'api_entreprise/ping_providers',
          action: 'show'
        },
        {
          controller: 'api_entreprise/ping_providers',
          action: 'index'
        },
        {
          controller: 'api_entreprise/privileges',
          action: 'index'
        },
        {
          controller: 'api_particulier/france_connect_jwks',
          action: 'show'
        },
        {
          controller: 'api_particulier/ping_providers',
          action: 'show'
        },
        {
          controller: 'api_particulier/ping_providers',
          action: 'index'
        }
      ]
    end

    let(:throttle_config) { Rails.application.config_for(:throttle) }

    let(:throttled_endpoints) do
      config = throttle_config.values.pluck(:endpoints).flatten

      config.map { |conf| conf.slice(:controller, :action) }.uniq
    end

    it 'throttles the resources' do
      expect(all_routes.uniq).to match_array(throttled_endpoints)
    end
  end
end
