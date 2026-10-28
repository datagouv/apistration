class EditorDelegation::Create < ApplicationInteractor
  def call
    ensure_authorization_request_open!

    context.editor = find_editor
    context.delegation = create_delegation
  rescue ActiveRecord::RecordNotFound
    fail!('Editor not found or not delegable', :warning, editor_id: context.editor_id)
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    fail!(e.message, :warning)
  end

  private

  def ensure_authorization_request_open!
    return if context.authorization_request.eligible_for_token_creation?

    context.fail!(message: I18n.t('concerns.delegations_management.create.error.closed'))
  end

  def find_editor
    Editor.delegable.find(context.editor_id)
  end

  def create_delegation
    EditorDelegation.create!(
      editor: context.editor,
      authorization_request: context.authorization_request
    )
  end
end
