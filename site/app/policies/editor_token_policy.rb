class EditorTokenPolicy < ApplicationPolicy
  alias editor_token record

  def create?
    user.editor?
  end

  def update?
    manageable?
  end

  def rotate?
    manageable?
  end

  def revoke?
    manageable?
  end

  private

  def manageable?
    user.editor? && editor_token.editor == user.editor && editor_token.active?
  end
end
