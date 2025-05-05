class SDH::ValidateIdentifiant < ValidateParamInteractor
  def call
    return if param(:identifiant).present? && digits_only?

    invalid_param!(:identifiant)
  end

  private

  def digits_only?
    param(:identifiant).to_s.match?(/\A\d+\z/)
  end
end
