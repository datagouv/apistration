class Admin::EditorTokensController < AdminController
  def create
    @editor = Editor.find(params.expect(:editor_id))

    Admin::EditorTokens::Create.call(editor: @editor, admin: true_user, namespace:)

    success_message(title: 'Jeton éditeur créé avec succès')
    redirect_to admin_editor_path(@editor, onglet: 'technical')
  end
end
