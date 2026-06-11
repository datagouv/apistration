class Admin::Editor::RemoveMember < ApplicationInteractor
  def call
    context.user = context.editor.users.find(context.user_id)
    context.user.update!(editor: nil)
  rescue ActiveRecord::RecordNotFound
    context.fail!(message: 'Membre non trouvé')
  end
end
