class ServiceUser::ValidateTokenId < ValidateUuid
  raises UnprocessableEntityError, field: :token_id

  def attribute
    :token_id
  end
end
