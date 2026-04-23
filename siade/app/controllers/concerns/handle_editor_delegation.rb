module HandleEditorDelegation
  extend ActiveSupport::Concern

  included do
    skip_before_action :authorize_access_to_resource!

    before_action :verify_editor_delegation!, if: :editor_token?
    before_action :authorize_access_to_resource!
  end

  private

  def editor_token?
    current_user&.editor?
  end

  def verify_editor_delegation!
    if request.env[UserResolutionMiddleware::DELEGATION_AMBIGUOUS_ENV_KEY]
      render_ambiguous_delegation
      return
    end

    raise HandleTokens::NotAuthorizedError unless request.env[UserResolutionMiddleware::DELEGATION_ENV_KEY]
  end

  def render_ambiguous_delegation
    render json: ErrorsSerializer.new([AmbiguousDelegationError.new], format: error_format).as_json,
      status: :unprocessable_content
  end
end
