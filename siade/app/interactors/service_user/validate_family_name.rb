class ServiceUser::ValidateFamilyName < ValidateAttributePresence
  def attribute
    :family_name
  end
end
