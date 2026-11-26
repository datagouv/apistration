class Editor::SettingsController < EditorController
  before_action :set_section

  def show
    @editor = current_editor
  end

  def update
    @editor = current_editor

    if @editor.update(settings_params)
      success_message(title: 'Informations mises à jour')
      redirect_to editor_settings_path(onglet: @section.key)
    else
      error_message(title: 'Erreur lors de la mise à jour de vos informations')
      render 'show', status: :unprocessable_content
    end
  end

  private

  def set_section
    @section = EditorProfileSection.find(params.fetch(:onglet, nil))
  end

  def settings_params
    params.expect(editor: @section.permitted_attributes(admin: false))
  end
end
