class ServiceUser::ValidateUserId < ValidateUuid
  raises UnprocessableEntityError, field: :user_id

  def attribute
    :user_id
  end
end
