class EditorDecorator < ApplicationDecorator
  delegate_all

  def role_label
    I18n.t(role || :unknown, scope: 'editors.roles')
  end

  def two_factor_label
    return h.content_tag(:span, 'Non renseigné', class: 'fr-text-mention--grey') if two_factor_status.nil?

    label = I18n.t(two_factor_status, scope: 'editors.two_factor_statuses')
    two_factor_in_progress? ? "#{label} (échéance #{I18n.l(two_factor_deadline)})" : label
  end

  def deployment_type_label
    I18n.t(deployment_type || :unknown, scope: 'editors.deployment_types')
  end
end
