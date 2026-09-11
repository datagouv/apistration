class ACOSS::AttestationsSociales::ValidateUserIdPresence < ValidateAttributePresence
  raises UnprocessableEntityError, field: :user_id

  def attribute
    :user_id
  end
end
