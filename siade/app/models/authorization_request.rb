class AuthorizationRequest < ApplicationRecord
  has_many :tokens,
    class_name: 'Token',
    foreign_key: 'authorization_request_model_id',
    inverse_of: :authorization_request
end
