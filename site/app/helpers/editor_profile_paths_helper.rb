module EditorProfilePathsHelper
  def editor_profile_path_for(editor, section_key, admin:)
    admin ? admin_editor_path(editor, onglet: section_key) : editor_settings_path(onglet: section_key)
  end

  def editor_profile_use_cases_path(editor, admin:)
    admin ? admin_editor_use_cases_path(editor) : editor_use_cases_path
  end

  def editor_profile_use_case_path(editor, use_case, admin:)
    admin ? admin_editor_use_case_path(editor, use_case) : editor_use_case_path(use_case)
  end

  def editor_profile_new_use_case_path(editor, admin:, **)
    admin ? new_admin_editor_use_case_path(editor, **) : new_editor_use_case_path(**)
  end

  def editor_profile_edit_use_case_path(editor, use_case, admin:, **)
    admin ? edit_admin_editor_use_case_path(editor, use_case, **) : edit_editor_use_case_path(use_case, **)
  end

  def editor_profile_contacts_path(editor, admin:)
    admin ? admin_editor_contacts_path(editor) : editor_contacts_path
  end

  def editor_profile_contact_path(editor, contact, admin:)
    admin ? admin_editor_contact_path(editor, contact) : editor_contact_path(contact)
  end
end
