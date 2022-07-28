class APIEntreprise::V2::PrivilegesController < APIEntreprise::V2::BaseController
  skip_before_action :context_is_filled!

  def show
    render json: {
      privileges: privileges
    }, status: :ok
  end

  def privileges
    user_from_jwt.scopes
  end
end
