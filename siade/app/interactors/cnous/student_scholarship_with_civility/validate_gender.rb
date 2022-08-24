class CNOUS::StudentScholarshipWithCivility::ValidateGender < ValidateParamInteractor
  def call
    invalid_param!(:gender) if param(:gender).blank?

    return if %w[M F].include?(param(:gender))

    invalid_param!(:gender)
  end
end
