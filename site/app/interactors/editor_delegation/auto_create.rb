class EditorDelegation::AutoCreate < ApplicationInteractor
  def call
    return if %w[approve validate].exclude?(context.event)
    return if editor.nil?
    return warn_editor_not_delegable unless editor.delegations_enabled?

    context.delegation = EditorDelegation.active.find_or_create_by!(
      editor:,
      authorization_request: context.authorization_request
    ) do |delegation|
      delegation.created_via = 'datapass_auto'
    end
  end

  private

  def editor
    return @editor if defined?(@editor)

    @editor = Editor.find_by(':demarche = ANY(form_uids)', demarche: context.authorization_request.demarche)
  end

  def warn_editor_not_delegable
    Sentry.set_context(
      'Editor delegation auto-creation',
      editor_id: editor.id,
      authorization_request_id: context.authorization_request.id
    )
    Sentry.capture_message(
      "Editor #{editor.name} matches form #{context.authorization_request.demarche} but is not delegable",
      level: :warning
    )
  end
end
