class EditorUseCasePolicy < ApplicationPolicy
  alias use_case record

  def update?
    owner?
  end

  def destroy?
    owner? && use_case.form_uid.nil?
  end

  private

  def owner?
    user.editor.present? && use_case.editor == user.editor
  end
end
