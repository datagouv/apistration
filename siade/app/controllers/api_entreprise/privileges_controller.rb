class APIEntreprise::PrivilegesController < APIEntrepriseController
  skip_before_action :context_is_filled!

  def index
    render json: {
      data: {
        privileges:
      }
    }, status: :ok
  end

  private

  def privileges
    current_user.scopes
  end

  def error_format
    :json_api
  end

  def operation_id
    OperationIdResolver.controller_to_operation_id(controller_path)
  end
end
