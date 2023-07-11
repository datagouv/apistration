class Token < ApplicationRecord
  belongs_to :authorization_request, foreign_key: 'authorization_request_model_id', inverse_of: :tokens

  def siret
    authorization_request.try(:siret)
  end
end
