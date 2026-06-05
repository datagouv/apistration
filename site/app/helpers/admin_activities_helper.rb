module AdminActivitiesHelper
  def admin_activity_action_label(activity)
    t("admin_activities.names.#{activity.name}", default: activity.name)
  end

  def admin_activity_entity(activity)
    return '—' if activity.entity_type.blank?

    label = "#{activity.entity_type} ##{activity.entity_id}"

    case activity.entity_type
    when 'User'
      link_to(label, edit_admin_user_path(activity.entity_id))
    when 'Editor'
      link_to(label, edit_admin_editor_path(activity.entity_id))
    else
      label
    end
  end

  def admin_activity_details(activity)
    rows = activity.after_attributes.map do |key, after_value|
      before_value = activity.before_attributes[key]

      if activity.before_attributes.key?(key) && before_value != after_value
        "#{key} : #{format_admin_activity_value(before_value)} → #{format_admin_activity_value(after_value)}"
      else
        "#{key} : #{format_admin_activity_value(after_value)}"
      end
    end

    return '—' if rows.empty?

    safe_join(rows.map { |row| content_tag(:div, row, class: 'fr-text--sm') })
  end

  def format_admin_activity_value(value)
    return '∅' if value.nil?
    return value.join(', ') if value == [*value]

    value.to_s
  end
end
