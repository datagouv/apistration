class Admin::EditorUseCasesController < AdminController
  before_action :set_editor

  def new
    @use_case = EditorUseCase.prefill(@editor.use_cases.build(integration_status: 'production'), params.fetch(:use_case, nil))
  end

  def edit
    @use_case = EditorUseCase.prefill(@editor.use_cases.find(params.expect(:id)), params.fetch(:use_case, nil))
  end

  def create
    result = Admin::EditorUseCases::Create.call(editor: @editor, record_params: use_case_params, admin: true_user, namespace:)
    render_result(result, 'new', 'Démarche ajoutée')
  end

  def update
    result = Admin::EditorUseCases::Update.call(editor: @editor, record_id: params.expect(:id), record_params: use_case_params, admin: true_user, namespace:)
    render_result(result, 'edit', 'Démarche mise à jour')
  end

  def destroy
    result = Admin::EditorUseCases::Destroy.call(editor: @editor, record_id: params.expect(:id), admin: true_user, namespace:)
    result.success? ? success_message(title: 'Démarche retirée') : error_message(title: result.message)

    redirect_to admin_editor_path(@editor, onglet: 'use_cases')
  end

  private

  def set_editor
    @editor = Editor.find(params.expect(:editor_id))
  end

  def use_case_params
    params.expect(editor_use_case: EditorUseCase::EDITABLE_ATTRIBUTES + EditorUseCase::ADMIN_ATTRIBUTES)
  end

  def render_result(result, failure_template, success_title)
    @use_case = result.record

    if result.success? || @use_case.nil?
      result.success? ? success_message(title: success_title) : error_message(title: result.message)
      redirect_to admin_editor_path(@editor, onglet: 'use_cases')
    else
      render failure_template, status: :unprocessable_content
    end
  end
end
