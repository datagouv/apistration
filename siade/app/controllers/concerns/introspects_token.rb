module IntrospectsToken
  extend ActiveSupport::Concern

  include HandleEditorDelegation

  included do
    include VersionAware

    before_action :verify_api_version!

    rescue_from VersionAware::UnsupportedVersionError, with: :unsupported_version_response
  end

  def show
    render json: serializer_class.new(current_user, delegation: editor_delegation, authorization_request:).as_json, status: :ok
  end

  private

  def editor_delegation_required?
    editor_token? && params[:recipient].present?
  end

  def editor_delegation
    request.env[UserResolutionMiddleware::DELEGATION_ENV_KEY]
  end

  def authorization_request
    return editor_delegation.authorization_request if editor_delegation
    return if current_user.authorization_request_id.blank?

    AuthorizationRequest.find_by(id: current_user.authorization_request_id)
  end

  def serializer_module
    ::IntrospectionSerializer
  end
end
