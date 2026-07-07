class DatapassWebhook::CreateEditorDelegation < ApplicationInteractor
  def call
    return if %w[approve validate].exclude?(context.event)
    return if editor.nil?

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
end
