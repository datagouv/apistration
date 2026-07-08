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
      render_generic_errors_serializer(AmbiguousDelegationError, status: :unprocessable_content)
      return
    end

    return if request.env[UserResolutionMiddleware::DELEGATION_ENV_KEY]

    raise HandleTokens::NotAuthorizedError if params[:recipient].blank?

    render_generic_errors_serializer(DelegationSiretMismatchError, status: :forbidden)
  end
end
