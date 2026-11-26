class EditorContactPolicy < ApplicationPolicy
  alias contact record

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user.editor.present? && contact.editor == user.editor
  end
end
