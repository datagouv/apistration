class Editor::SettingsController < EditorController
  def show
    @editor = current_editor
  end

  def update
    @editor = current_editor

    if @editor.update(settings_params)
      success_message(title: 'Paramètres mis à jour')
      redirect_to editor_settings_path
    else
      error_message(title: 'Erreur lors de la mise à jour des paramètres')
      render 'show', status: :unprocessable_content
    end
  end

  private

  def settings_params
    params.expect(
      editor: %i[
        name
        siret
        description
        deployment_type
        languages
        contact_email
        contact_phone
        domain
      ]
    )
  end
end
