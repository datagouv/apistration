module NomenclatureCoverageGuard
  API_FOR_NAMESPACE = {
    'APIEntreprise' => :entreprise,
    'APIParticulier' => :particulier
  }.freeze

  def self.verify!(request, response)
    rendered = rendered_codes(response)
    return if rendered.empty?

    controller = request.params['controller'].to_s
    return report_undeclared_by_any_layer(rendered) if controller.empty?

    controller_class = documented_controller_class(controller)
    return if controller_class.nil?

    report_undocumented(controller_class, request.params['api_version'], rendered)
  end

  def self.report_undeclared_by_any_layer(rendered)
    undocumented = rendered - API_FOR_NAMESPACE.values.flat_map { |api| codes_of(nomenclature_for(api)['platform_codes']) }

    return if undocumented.empty?

    raise "a middleware renders #{undocumented.inspect} before any endpoint runs, absent from the errors nomenclature. " \
          'An error rendered outside a controller reaches every endpoint: add it to Errors::BaselineErrors#platform.'
  end

  def self.report_undocumented(controller_class, api_version, rendered)
    api = API_FOR_NAMESPACE.fetch(controller_class.name.split('::').first)
    operation_id = operation_id(controller_class, api_version)
    undocumented = rendered - documented_codes(api, operation_id)

    return if undocumented.empty?

    raise "#{operation_id} renders #{undocumented.inspect}, absent from the errors nomenclature. " \
          'An error a request can return must be declared on its organizer or added to Errors::BaselineErrors#platform.'
  end

  def self.rendered_codes(response)
    return [] unless response&.media_type.to_s.include?('json')

    body = JSON.parse(response.body)
    return [] unless body.respond_to?(:dig)

    Array(body['errors']).filter_map { |error| error['code'] if error.respond_to?(:dig) }
  rescue StandardError
    []
  end

  def self.documented_controller_class(controller)
    return unless controller.include?('v3_and_more')

    controller_class = constantize_controller(controller)
    return unless controller_class.respond_to?(:errors_nomenclature_declaration)

    controller_class if controller_class.errors_nomenclature_declaration&.documented?
  end

  def self.constantize_controller(controller)
    "#{controller}_controller".camelize
      .sub('ApiEntreprise', 'APIEntreprise')
      .sub('ApiParticulier', 'APIParticulier')
      .safe_constantize
  end

  def self.operation_id(controller_class, api_version)
    controller = controller_class.new
    controller.params = { api_version: api_version.to_i }

    controller.send(:operation_id)
  end

  def self.documented_codes(api, operation_id)
    nomenclature = nomenclature_for(api)

    codes_of(nomenclature['platform_codes']) + codes_of(nomenclature.dig('endpoints', operation_id, 'errors'))
  end

  def self.codes_of(errors_by_status)
    errors_by_status.to_h.values.flatten.pluck('code')
  end

  def self.nomenclature_for(api)
    @nomenclature_for ||= {}
    @nomenclature_for[api] ||= ErrorsNomenclature.new(api).to_h
  end
end

RSpec.configure do |config|
  config.after(:each, type: :request) do
    NomenclatureCoverageGuard.verify!(request, response)
  end
end
