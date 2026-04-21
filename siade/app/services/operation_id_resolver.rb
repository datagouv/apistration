class OperationIdResolver
  def self.resolve(operation_id)
    mapping.fetch(operation_id) do
      raise "Unknown operation_id in throttle config: #{operation_id}"
    end
  end

  def self.mapping
    @mapping ||= build_mapping
  end

  def self.reset!
    @mapping = nil
  end

  def self.build_mapping
    result = {}

    Rails.application.routes.routes.each do |route|
      next if route.defaults.empty?

      controller = route.defaults[:controller]
      action = route.defaults[:action]
      next unless controller && action

      op_id = controller_to_operation_id(controller)
      next unless op_id

      result[op_id] ||= { controller:, action: }
    end

    result
  end

  def self.controller_to_operation_id(controller)
    api_name, version_segment, *parts = controller.split('/')

    if version_segment == 'v3_and_more'
      [api_name, 'v3', parts].flatten.join('_')
    elsif parts.empty? && version_segment.nil?
      api_name
    else
      [api_name, version_segment, parts].flatten.compact.join('_')
    end
  end
end
