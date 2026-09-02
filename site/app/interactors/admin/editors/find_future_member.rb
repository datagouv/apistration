class Admin::Editors::FindFutureMember < ApplicationInteractor
  def call
    context.user = find_user
    validate_not_already_member
  end

  private

  def find_user
    User.find_by(email: context.email) ||
      context.fail!(message: "Aucun utilisateur trouvé avec l'email #{context.email}")
  end

  def validate_not_already_member
    return unless context.user.editor_id == context.editor.id

    context.fail!(message: "#{context.user.email} est déjà membre de cet éditeur")
  end
end
