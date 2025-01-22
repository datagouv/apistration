class APIEntreprise::V3AndMore::BaseController < APIEntrepriseController
  include VersionAware
  include UseRetrievers
  include RecipientManagement

  before_action :verify_api_version!
  before_action :verify_recipient_is_a_siret!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  protected

  def cache_key
    request.path
  end

  def serialize_data
    if organizer.mocked_data.present?
      organizer.mocked_data[:payload]
    else
      serializer_class.new(organizer.bundled_data, current_user).serializable_hash
    end
  end

  def render_errors
    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new(organizer.errors, format: error_format).as_json,
      status:       extract_http_code(organizer)
  end

  def error_format
    :json_api
  end

  def content_type_header
    'application/vnd.api+json'
  end

  def set_content_type_header!
    response.headers['Content-Type'] = content_type_header
  end
end
