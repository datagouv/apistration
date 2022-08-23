class ServiceUser::ValidateFirstName < ValidateAttributePresence
  def attribute
    :first_name
  end
end
