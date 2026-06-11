class Admin::EditorMembersController < AdminController
  before_action :set_editor

  def create
    result = Admin::Editor::AddMember.call(editor: @editor, email: params[:email])

    if result.success?
      success_message(title: "#{result.user.email} ajouté à l'éditeur #{@editor.name}")
    else
      error_message(title: result.message)
    end

    redirect_to admin_editor_path(@editor)
  end

  def destroy
    result = Admin::Editor::RemoveMember.call(editor: @editor, user_id: params.expect(:id))

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
