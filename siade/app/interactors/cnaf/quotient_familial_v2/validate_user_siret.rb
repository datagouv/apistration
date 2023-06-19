class CNAF::QuotientFamilialV2::ValidateUserSiret < ValidateParamInteractor
  def call
    return if siret.valid?

    invalid_param!(:siret)
  end

  private

  def siret
    @siret ||= Siret.new(param(:user_siret))
  end
end
