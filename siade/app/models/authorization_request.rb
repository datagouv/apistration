class AuthorizationRequest < ApplicationRecord
  has_many :tokens,
    class_name: 'Token',
    foreign_key: 'authorization_request_model_id',
    inverse_of: :authorization_request

  has_one :security_settings,
    class_name: 'AuthorizationRequestSecuritySettings',
    dependent: :destroy
end
