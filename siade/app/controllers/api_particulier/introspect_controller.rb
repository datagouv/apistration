# frozen_string_literal: true

class APIParticulier::IntrospectController < APIParticulierController
  def show
    render json: introspect_payload, status: :ok
  end

  private

  def introspect_payload
    {
      '_id' => current_user.jti,
      'name' => '',
      'scopes' => current_user.scopes
    }
  end
end
