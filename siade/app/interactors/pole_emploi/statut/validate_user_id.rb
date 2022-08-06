class PoleEmploi::Statut::ValidateUserId < ValidateUuid
  def attribute
    :user_id
  end
end
