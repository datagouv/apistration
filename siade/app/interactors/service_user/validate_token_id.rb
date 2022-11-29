class ServiceUser::ValidateTokenId < ValidateUuid
  def attribute
    :token_id
  end
end
