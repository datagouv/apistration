require 'yaml'
require 'json'

class MockDataBackend
  PAYLOADS_ROOT = Rails.root.join('config/mock_payloads')

  class UnknownDeclaredError < StandardError; end

  class << self
    def get_response_for(operation_id, params)
      payloads_for(operation_id)[params.to_query]
    end

    def get_not_found_response_for(operation_id)
      payloads_for(operation_id)['not_found']
    end

    def reset!
      @cache = nil
    end

    private

    def payloads_for(operation_id)
      cache[operation_id] ||= load_payloads(operation_id)
    end

    def cache
      @cache ||= {}
    end

    def load_payloads(operation_id)
      dir = PAYLOADS_ROOT.join(operation_id)
      return {} unless dir.directory?

      dir.children.each_with_object({}) do |path, result|
        next unless path.extname.in?(['.yaml', '.yml'])

        key, value = build_payload(path)
        result[key] = value
        result['not_found'] = value if path.basename.to_s == '404.yaml'
      end
    end

    def build_payload(path)
      content = YAML.load_file(path)

      [
        deep_downcase(content['params']).to_query,
        {
          status: content['status'],
          declared_error: declared_error(content['declared_error']),
          payload: JSON.parse(content['payload'])
        }.compact
      ]
    end

    def declared_error(name)
      return if name.nil?

      declaration = name.safe_constantize
      raise UnknownDeclaredError, "#{name} is not an error declaration" unless declaration.is_a?(ErrorRegistry::Declaration)

      declaration
    end

    def deep_downcase(hash)
      hash.deep_transform_values { |v| v.is_a?(String) ? v.downcase : v }
    end
  end
end
