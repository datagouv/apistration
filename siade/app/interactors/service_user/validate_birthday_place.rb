class ServiceUser::ValidateBirthdayPlace < ValidateAttributePresence
  def attribute
    :birth_place
  end
end
