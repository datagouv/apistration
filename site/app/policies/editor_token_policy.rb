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

  def prolong?
    owner? && day_left < 90 && !editor_token.blacklisted?
  end

  private

  def manageable?
    user.editor? && editor_token.editor == user.editor && editor_token.active?
  end

  def owner?
    user.editor == editor_token.editor
  end

  def day_left
    (editor_token.exp - Time.zone.now.to_i) / 1.day
  end
end
