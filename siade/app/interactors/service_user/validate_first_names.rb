class ServiceUser::ValidateFirstNames < ValidateAttributePresence
  def attribute
    :first_names
  end
end
