class ErrorsNomenclature
  STATUS_PRIORITY = %w[422 404 502].freeze

  attr_reader :api

  def initialize(api)
    @api = api.to_sym
  end

  def to_h
    {
      'api' => api.to_s,
      'providers' => errors_backend.providers,
      'generic_subcodes' => errors_backend.generic_subcodes,
      'platform_codes' => group_by_status(baseline.platform),
      'endpoints' => endpoints
    }
  end

  private

  def endpoints
    documented_controller_classes.flat_map { |controller_class|
      controller_class.errors_nomenclature_declaration.organizers.map do |version, organizer|
        [operation_id(controller_class, version), endpoint_entry(controller_class, organizer)]
      end
    }.sort_by(&:first).to_h
  end

  def documented_controller_classes
    controller_classes.select { |controller_class| controller_class.errors_nomenclature_declaration.documented? }
  end

  def endpoint_entry(controller_class, organizer)
    provider_name = organizer.provider_name

    {
      'provider' => provider_name,
      'errors' => group_by_status(endpoint_errors(controller_class, organizer, provider_name))
    }
  end

  def endpoint_errors(controller_class, organizer, provider_name)
    (baseline.for_provider(provider_name) +
      declared_errors(organizer, provider_name) +
      france_connect_errors(controller_class))
      .reject { |error| platform_error_codes.include?(error.code) }
  end

  def platform_error_codes
    @platform_error_codes ||= baseline.platform.map(&:code)
  end

  def declared_errors(organizer, provider_name)
    ErrorRegistry.declarations_for_organizer(organizer).map { |declaration| declaration.build(provider_name:) }
  end

  def france_connect_errors(controller_class)
    return [] unless controller_class.include?(APIParticulier::RequiresFranceConnect)

    provider_name = FranceConnect::DataFetcherThroughAccessToken.provider_name

    [InvalidFranceConnectAccessTokenError.new(:missing_france_connect_access_token)] +
      baseline.for_token_provider(provider_name) +
      declared_errors(FranceConnect::DataFetcherThroughAccessToken, provider_name)
  end

  def group_by_status(errors)
    errors
      .uniq(&:code)
      .group_by { |error| status_of(error) }
      .transform_values { |grouped| grouped.sort_by(&:code).map { |error| serialize(error) } }
      .sort_by { |status, _| status_rank(status) }
      .to_h
  end

  def status_rank(status)
    [STATUS_PRIORITY.index(status) || STATUS_PRIORITY.size, status]
  end

  def status_of(error)
    Rack::Utils.status_code(Errors::HTTPStatusForKind.call(error.kind)).to_s
  end

  def serialize(error)
    {
      'code' => error.code,
      'title' => error.title,
      'detail' => error.detail,
      'meta' => error.meta.deep_stringify_keys.presence
    }.compact
  end

  def controller_classes
    Rails.application.routes.routes.filter_map { |route|
      controller = route.defaults[:controller]
      next unless controller&.start_with?("api_#{api}/v3_and_more/")

      controller_class_for(controller)
    }.uniq
  end

  def controller_class_for(controller)
    "#{controller}_controller".camelize
      .sub('ApiEntreprise', 'APIEntreprise')
      .sub('ApiParticulier', 'APIParticulier')
      .constantize
  end

  def operation_id(controller_class, version)
    controller = controller_class.new
    controller.params = { api_version: version }

    controller.send(:operation_id)
  end

  def baseline
    @baseline ||= Errors::BaselineErrors.new(api)
  end

  def errors_backend
    ErrorsBackend.instance
  end
end
