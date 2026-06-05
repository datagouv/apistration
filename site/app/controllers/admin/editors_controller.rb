class Admin::EditorsController < AdminController
  def index
    @editors = Editor.includes(:users).page(params[:page])
  end

  def edit
    @editor = Editor.find(params.expect(:id))
  end

  def update
    @editor = Editor.find(params.expect(:id))

    result = Admin::Editors::Update.call(editor: @editor, editor_params: editor_update_params, admin: true_user, namespace:)

    if result.success?
      success_message(title: 'Éditeur mis à jour')

      redirect_to admin_editors_path
    else
      error_message(title: 'Erreur lors de la mise à jour de l\'éditeur')

      render 'edit', status: :unprocessable_content
    end
  end

  private

  def editor_update_params
    params.expect(
      editor: %i[
        name
        form_uids
        copy_token
        delegations_enabled
      ]
    ).tap do |whitelisted|
      whitelisted[:form_uids] = (whitelisted[:form_uids] || '').split(',').map(&:strip)
    end
  end
end
