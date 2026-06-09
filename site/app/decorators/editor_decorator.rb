class EditorDecorator < ApplicationDecorator
  delegate_all

  def role_label
    I18n.t(role || :unknown, scope: 'editors.roles')
  end

  def deployment_type_label
    I18n.t(deployment_type || :unknown, scope: 'editors.deployment_types')
  end
end
