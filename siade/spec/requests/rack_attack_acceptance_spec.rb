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

      it 'has operation_id strings as endpoints' do
        throttle_config.each do |group_name, config|
          config[:endpoints].each_with_index do |operation_id, index|
            expect(operation_id).to be_a(String).and(be_present),
              "Group '#{group_name}', endpoint #{index}: must be a non-empty operation_id string"
          end
        end
      end
    end
  end

  describe 'endpoint definitions' do
    let(:all_operation_ids) do
      throttle_config.values.flat_map { |config| config[:endpoints] }
    end

    it 'has no duplicate endpoints across all throttle groups' do
      duplicates = all_operation_ids.select { |e| all_operation_ids.count(e) > 1 }.uniq

      expect(duplicates).to be_empty,
        "Found duplicate operation_ids in config: #{duplicates.join(', ')}"
    end

    it 'all configured operation_ids resolve to actual routes' do
      all_operation_ids.each do |operation_id|
        expect { OperationIdResolver.resolve(operation_id) }.not_to raise_error,
          "operation_id '#{operation_id}' does not resolve to any route"
      end
    end

    describe 'consistency with OpenAPI specs' do
      let(:swagger_operation_ids) do
        %w[openapi-entreprise.yaml openapi-particulier.yaml].flat_map { |file|
          spec = YAML.safe_load_file(Rails.root.join('swagger', file), aliases: true, permitted_classes: [Date])

          spec['paths'].flat_map do |_path, methods|
            methods.filter_map do |_verb, definition|
              definition.dig('responses', '200', 'x-operationId') if definition.is_a?(Hash)
            end
          end
        }.compact
      end

      let(:non_swagger_operation_ids) do
        %w[
          api_entreprise_inpi_proxy
          api_entreprise_proxied_files
          api_entreprise_v3_inpi_rne_beneficiaires_effectifs_open_data
          mcp
        ]
      end

      let(:non_throttled_swagger_operation_ids) do
        %w[api_entreprise_vrivileges_]
      end

      it 'all throttled operation_ids exist in the OpenAPI specs (except internal endpoints)' do
        missing = all_operation_ids
          .reject { |op_id| non_swagger_operation_ids.include?(op_id) }
          .reject do |op_id|
            swagger_operation_ids.any? do |swagger_op_id|
              swagger_op_id == op_id || swagger_op_id == op_id.sub('_v3_', '_v4_')
            end
          end

        expect(missing).to be_empty,
          "operation_ids in throttle.yml not found in OpenAPI specs: #{missing.join(', ')}"
      end

      it 'all OpenAPI endpoints have a throttle config' do
        unthrottled = swagger_operation_ids
          .reject { |op_id| non_throttled_swagger_operation_ids.include?(op_id) }
          .reject do |swagger_op_id|
            normalized = swagger_op_id.sub(/_v\d+_/, '_v3_')
            all_operation_ids.include?(swagger_op_id) || all_operation_ids.include?(normalized)
          end

        expect(unthrottled).to be_empty,
          "OpenAPI endpoints missing from throttle.yml: #{unthrottled.join(', ')}"
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
      throttle_config.values.flat_map { |config|
        config[:endpoints].map { |op_id| OperationIdResolver.resolve(op_id) }
      }.uniq
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
