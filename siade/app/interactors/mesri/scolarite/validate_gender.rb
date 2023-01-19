class MESRI::Scolarite::ValidateGender < ValidateParamInteractor
  def call
    invalid_param!(:gender) if param(:gender).blank?

    return if [1, 2].include?(param(:gender))

    invalid_param!(:gender)
  end
end
