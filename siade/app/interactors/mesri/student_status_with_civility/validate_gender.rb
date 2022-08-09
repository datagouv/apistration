class MESRI::StudentStatusWithCivility::ValidateGender < ValidateParamInteractor
  def call
    invalid_param!(:gender) if param(:gender).blank?

    return if %w[m f].include?(param(:gender))

    invalid_param!(:gender)
  end
end
