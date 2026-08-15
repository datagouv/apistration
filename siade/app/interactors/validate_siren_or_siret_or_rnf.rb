class ValidateSirenOrSiretOrRNF < ValidateParamInteractor
  def call
    return if rnf_id.valid? || siret.valid? || siren.valid?

    invalid_param!(:siren_or_siret_or_rnf)
  end

  private

  def rnf_id
    @rnf_id ||= RNFId.new(siren_or_siret_or_rnf)
  end

  def siret
    @siret ||= Siret.new(siren_or_siret_or_rnf)
  end

  def siren
    @siren ||= Siren.new(siren_or_siret_or_rnf)
  end

  def siren_or_siret_or_rnf
    context.params[:siren_or_siret_or_rnf]
  end
end
