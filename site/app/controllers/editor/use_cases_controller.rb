class Editor::UseCasesController < EditorController
  before_action :set_use_case, only: %i[edit update destroy]

  def new
    @use_case = EditorUseCase.prefill(current_editor.use_cases.build(integration_status: 'production'), params.fetch(:use_case, nil))
  end

  def edit
    EditorUseCase.prefill(@use_case, params.fetch(:use_case, nil))
  end

  def create
    @use_case = current_editor.use_cases.build(use_case_params)

    if @use_case.save
      success_message(title: "Cas d'usage ajouté")
      redirect_to editor_settings_path(onglet: 'use_cases')
    else
      render 'new', status: :unprocessable_content
    end
  end

  def update
    if @use_case.update(use_case_params)
      success_message(title: "Cas d'usage mis à jour")
      redirect_to editor_settings_path(onglet: 'use_cases')
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    if @use_case.form_uid
      error_message(title: "Ce cas d'usage est rattaché à un formulaire DataPass : écrivez au support pour le retirer")
    else
      @use_case.destroy!
      success_message(title: "Cas d'usage retiré")
    end

    redirect_to editor_settings_path(onglet: 'use_cases')
  end

  private

  def set_use_case
    @use_case = current_editor.use_cases.find(params.expect(:id))
  end

  def use_case_params
    params.expect(editor_use_case: EditorUseCase::EDITABLE_ATTRIBUTES)
  end
end
