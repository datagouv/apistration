module APIParticulier::RequiresFranceConnect
  extend ActiveSupport::Concern

  include APIParticulier::FranceConnectable

  included do
    before_action :require_france_connect_access_token!
  end

  private

  def require_france_connect_access_token!
    return if france_connect?

    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new([InvalidFranceConnectAccessTokenError.new(:missing_france_connect_access_token)]).as_json,
      status:       :unauthorized
  end
end
