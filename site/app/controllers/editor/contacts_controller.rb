class Editor::ContactsController < EditorController
  def edit
    @contact = current_editor.contacts.find(params.expect(:id))
  end

  def create
    contact = current_editor.contacts.build(contact_params)

    if contact.save
      success_message(title: 'Contact ajouté')
    else
      error_message(title: contact.errors.full_messages.to_sentence)
    end

    redirect_to editor_settings_path(onglet: 'contacts')
  end

  def update
    @contact = current_editor.contacts.find(params.expect(:id))

    if @contact.update(contact_params)
      success_message(title: 'Contact mis à jour')
      redirect_to editor_settings_path(onglet: 'contacts')
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    current_editor.contacts.find(params.expect(:id)).destroy!
    success_message(title: 'Contact retiré')

    redirect_to editor_settings_path(onglet: 'contacts')
  end

  private

  def contact_params
    params.expect(editor_contact: EditorContact::EDITABLE_ATTRIBUTES)
  end
end
