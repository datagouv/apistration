module EditorProfileHelper
  def editor_profile_path_for(editor, section_key, admin:)
    admin ? admin_editor_path(editor, onglet: section_key) : editor_settings_path(onglet: section_key)
  end

  def editor_profile_contacts_path(editor, admin:)
    admin ? admin_editor_contacts_path(editor) : editor_contacts_path
  end

  def editor_profile_contact_path(editor, contact, admin:)
    admin ? admin_editor_contact_path(editor, contact) : editor_contact_path(contact)
  end

  def editor_profile_input_group(form, attribute, label, hint: nil, &)
    errors = form.object.errors[attribute]

    content_tag(:div, class: ['fr-input-group', ('fr-input-group--error' if errors.any?)]) do
      safe_join([
        form.label(attribute, class: 'fr-label') { safe_join([label, (content_tag(:span, hint, class: 'fr-hint-text') if hint)].compact) },
        capture(&),
        *errors.map { |message| content_tag(:p, message, class: 'fr-error-text') }
      ])
    end
  end

  def editor_profile_checkbox(form, attribute, label)
    content_tag(:div, class: 'fr-checkbox-group') do
      form.check_box(attribute, class: 'fr-checkbox') + form.label(attribute, label, class: 'fr-label')
    end
  end

  def editor_profile_readonly(label, value)
    content_tag(:div, class: 'fr-mb-3w') do
      safe_join([
        content_tag(:p, label, class: 'fr-text--sm fr-text--bold fr-mb-1v'),
        content_tag(:p, value.presence || editor_profile_blank, class: 'fr-mb-0')
      ])
    end
  end

  def editor_profile_blank
    content_tag(:span, 'Non renseigné', class: 'fr-text-mention--grey')
  end
end
