RSpec.describe 'Rack::Attack acceptance' do
  let(:throttle_config) { Rails.application.config_for(:throttle) }

  describe 'throttle configuration file structure' do
    it 'loads successfully' do
      expect { throttle_config }.not_to raise_error
    end

    it 'contains throttle groups' do
      expect(throttle_config).not_to be_empty
    end

    describe 'each throttle group' do
      it 'has all required fields' do
        throttle_config.each do |group_name, config|
          expect(config).to have_key(:throttle_type), "Group '#{group_name}' is missing throttle_type"
          expect(config).to have_key(:endpoints), "Group '#{group_name}' is missing endpoints"
          expect(config).to have_key(:limit), "Group '#{group_name}' is missing limit"
          expect(config).to have_key(:period), "Group '#{group_name}' is missing period"
        end
      end

      it 'has valid throttle_type values' do
        valid_types = %w[by_group_of_endpoints by_single_endpoint]

        throttle_config.each do |group_name, config|
          expect(valid_types).to include(config[:throttle_type]),
            "Group '#{group_name}' has invalid throttle_type: #{config[:throttle_type]}. " \
            "Must be one of: #{valid_types.join(', ')}"
        end
      end

      it 'has positive limit values' do
        throttle_config.each do |group_name, config|
          expect(config[:limit]).to be > 0, "Group '#{group_name}' has invalid limit: #{config[:limit]}"
        end
      end

      it 'has positive period values' do
        throttle_config.each do |group_name, config|
          expect(config[:period]).to be > 0, "Group '#{group_name}' has invalid period: #{config[:period]}"
        end
      end

      it 'has at least one endpoint' do
        throttle_config.each do |group_name, config|
          expect(config[:endpoints]).not_to be_empty, "Group '#{group_name}' has no endpoints"
        end
      end

      it 'has properly structured endpoints' do
        throttle_config.each do |group_name, config|
          config[:endpoints].each_with_index do |endpoint, index|
            expect(endpoint).to have_key(:controller),
              "Group '#{group_name}', endpoint #{index}: missing controller"
            expect(endpoint).to have_key(:action),
              "Group '#{group_name}', endpoint #{index}: missing action"
            expect(endpoint[:controller]).to be_a(String).and(be_present),
              "Group '#{group_name}', endpoint #{index}: controller must be a non-empty string"
            expect(endpoint[:action]).to be_a(String).and(be_present),
              "Group '#{group_name}', endpoint #{index}: action must be a non-empty string"
          end
        end
      end
    end
  end

  describe 'endpoint definitions' do
    let(:all_config_endpoints) do
      throttle_config.values.flat_map { |config| config[:endpoints] }
    end

    it 'has no duplicate endpoints across all throttle groups' do
      endpoint_keys = all_config_endpoints.map { |e| "#{e[:controller]}##{e[:action]}" }
      duplicates = endpoint_keys.select { |e| endpoint_keys.count(e) > 1 }.uniq

      expect(duplicates).to be_empty,
        "Found duplicate endpoints in config: #{duplicates.join(', ')}"
    end

    it 'all configured endpoints exist as actual routes' do
      all_route_endpoints = Rails.application.routes.routes.map { |route|
        next if route.defaults.empty?

        {
          controller: route.defaults[:controller],
          action: route.defaults[:action]
        }
      }.compact

      all_config_endpoints.each do |config_endpoint|
        expect(all_route_endpoints).to include(config_endpoint),
          "Endpoint #{config_endpoint[:controller]}##{config_endpoint[:action]} " \
          'is defined in throttle config but does not exist as a route'
      end
    end
  end

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

    let(:throttled_endpoints) do
      config = throttle_config.values.pluck(:endpoints).flatten

      config.map { |conf| conf.slice(:controller, :action) }.uniq
    end

    it 'ensures all routes (except non-throttled) are defined in throttle config' do
      expect(all_routes.uniq).to match_array(throttled_endpoints)
    end
  end

  describe 'throttle method compatibility' do
    it 'throttle methods exist for each configured type' do
      throttle_config.each do |group_name, config|
        method_name = "throttle_#{config[:throttle_type]}"
        expect(Rack::Attack).to respond_to(method_name),
          "Rack::Attack does not have method '#{method_name}' for group '#{group_name}'"
      end
    end
  end
end
