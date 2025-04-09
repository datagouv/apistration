class LogStasherFieldsBuilder
  attr_reader :controller, :fields

  delegate :bearer_token_from_headers,
    :request,
    :cached_retriever,
    :params,
    :token,
    to: :controller

  def initialize(controller, fields)
    @controller = controller
    @fields = fields
  end

  def perform
    add_api_version if api_entreprise? || api_particulier?

    api_entreprise_fields if api_entreprise?

    return unless api_particulier?

    api_particulier_fields
  end

  private

  def add_api_version
    fields[:api_version] = if api_namespace == 'v3_and_more'
                             "v#{params[:api_version]}"
                           else
                             api_namespace
                           end
  end

  def api_entreprise_fields
    fields[:api] = 'entreprise'

    begin
      fields[:retriever_cached] = cached_retriever.present? if api_namespace == 'v2'
    rescue NameError
      fields[:retriever_cached] = false
    end
  end

  def api_particulier_fields
    fields[:api] = 'particulier'
    fields[:parameters] = filtered_params

    add_hashed_params_for_logging
    add_france_connect_attributes_for_logging

    fields.delete(:parameters) if fields[:parameters].blank?
  end

  def controller_name
    @controller_name ||= request.params['controller']
  end

  def api_namespace
    @api_namespace ||= controller_name.split('/')[1]
  end

  def api_entreprise?
    controller_name =~ %r{\Aapi_entreprise/}
  end

  def api_particulier?
    controller_name =~ %r{\Aapi_particulier/}
  end

  def filtered_params
    @filtered_params ||= request.filtered_parameters.except('controller', 'action')
  end

  def add_hashed_params_for_logging
    return if request.params.except(:controller, :action).blank?

    add_param_field(:hashed_params, hashed_for_logs(request.params.except(:controller, :action).to_json))
  end

  def add_france_connect_attributes_for_logging
    return unless from_france_connect?

    add_param_field(:hashed_france_connect_token, hashed_for_logs(bearer_token_from_headers))
    add_param_field(:france_connect_client, extract_france_connect_client_infos_from_organizer)
  end

  def from_france_connect?
    france_connectable? &&
      controller.france_connect_organizer.success? &&
      controller.france_connect_organizer.mocked_data.blank?
  end

  def france_connectable?
    controller.class.included_modules.include?(APIParticulier::FranceConnectable) &&
      bearer_token_from_headers.present?
  end

  def extract_france_connect_client_infos_from_organizer
    france_connect_organizer = controller.france_connect_organizer

    {
      id: france_connect_organizer.client_attributes.client_id,
      name: france_connect_organizer.client_attributes.client_name,
      sub: france_connect_organizer.client_attributes.sub
    }
  end

  def add_param_field(key, value)
    fields[:parameters] ||= {}
    fields[:parameters][key] = value
  end

  def hashed_for_logs(data)
    Digest::SHA512.hexdigest("#{Siade.credentials[:api_particulier_log_salt_key]}:#{data}")
  end
end
