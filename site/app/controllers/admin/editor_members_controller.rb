class Admin::EditorMembersController < AdminController
  before_action :set_editor

  def create
    result = Admin::Editors::AddMember.call(editor: @editor, email: params[:email], admin: true_user, namespace:)

    if result.success?
      success_message(title: "#{result.user.email} ajouté à l'éditeur #{@editor.name}")
    else
      error_message(title: result.message)
    end

    redirect_to admin_editor_path(@editor)
  end

  def destroy
    result = Admin::Editors::RemoveMember.call(editor: @editor, user_id: params.expect(:id), admin: true_user, namespace:)

    if result.success?
      success_message(title: "#{result.user.email} retiré de l'éditeur #{@editor.name}")
    else
      error_message(title: result.message)
    end

    redirect_to admin_editor_path(@editor)
  end

  private

  def set_editor
    @editor = Editor.find(params.expect(:editor_id))
  end
end
