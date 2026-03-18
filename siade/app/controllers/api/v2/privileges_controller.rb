class API::V2::PrivilegesController < API::AuthenticateEntityController

  skip_before_action :context_is_filled!

  def show
    authorize :privileges

    render json: {
      privileges: privileges
    }, status: 200
  end

  def privileges
    user_from_jwt.roles
  end
end
