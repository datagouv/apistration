class API::V2::PrivilegesController < API::V2::BaseController
  skip_before_action :context_is_filled!

  def show
    authorize :privileges

    render json: {
      privileges: privileges
    }, status: :ok
  end

  def privileges
    user_from_jwt.scopes
  end
end
