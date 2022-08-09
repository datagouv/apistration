class MESRI::ValidateUserId < ValidateUuid
  def attribute
    :user_id
  end
end
