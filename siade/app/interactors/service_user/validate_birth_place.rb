class ServiceUser::ValidateBirthPlace < ValidateAttributePresence
  def attribute
    :birth_place
  end
end
