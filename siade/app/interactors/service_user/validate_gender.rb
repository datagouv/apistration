class ServiceUser::ValidateGender < ValidateParamInteractor
  def call
    return invalid_param!(:gender) if param(:gender).blank?

    return if %w[m f].include?(param(:gender).downcase)

    invalid_param!(:gender)
  end
end
