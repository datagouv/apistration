class Editor::ContactsController < EditorController
  def create
    contact = current_editor.contacts.build(params.expect(editor_contact: EditorContact::EDITABLE_ATTRIBUTES))

    if contact.save
      success_message(title: 'Contact ajouté')
    else
      error_message(title: contact.errors.full_messages.to_sentence)
    end

    redirect_to editor_settings_path(onglet: 'contacts')
  end

  def destroy
    current_editor.contacts.find(params.expect(:id)).destroy!
    success_message(title: 'Contact retiré')

    redirect_to editor_settings_path(onglet: 'contacts')
  end
end
