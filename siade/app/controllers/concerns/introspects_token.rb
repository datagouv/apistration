module IntrospectsToken
  extend ActiveSupport::Concern

  included do
    include VersionAware

    before_action :verify_api_version!

    rescue_from VersionAware::UnsupportedVersionError, with: :unsupported_version_response
  end

  def show
    render json: serializer_class.new(current_user, delegation: editor_delegation).as_json, status: :ok
  end

  private

  def editor_delegation
    request.env[UserResolutionMiddleware::DELEGATION_ENV_KEY]
  end

  def serializer_module
    ::IntrospectionSerializer
  end
end
