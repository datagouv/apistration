class ServiceUser::ValidateUserId < ValidateUuid
  def attribute
    :user_id
  end
end
