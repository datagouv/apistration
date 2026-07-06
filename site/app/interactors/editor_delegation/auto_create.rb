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
    @editor ||= Editor.for_demarche(context.authorization_request.demarche).take
  end

  def warn_editor_not_delegable
    MonitoringService.instance.track(
      "Editor #{editor.name} matches form #{context.authorization_request.demarche} but is not delegable",
      level: :warning,
      context: {
        editor_id: editor.id,
        authorization_request_id: context.authorization_request.id
      }
    )
  end
end
