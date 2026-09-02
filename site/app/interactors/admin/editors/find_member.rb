class Admin::Editors::FindMember < ApplicationInteractor
  def call
    context.user = context.editor.users.find(context.user_id)
  rescue ActiveRecord::RecordNotFound
    context.fail!(message: 'Membre non trouvé')
  end
end
