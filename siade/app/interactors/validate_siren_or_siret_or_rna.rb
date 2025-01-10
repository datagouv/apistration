class ValidateSirenOrSiretOrRNA < ValidateParamInteractor
  def call
    return if rna_id.valid? || siret.valid? || siren.valid?

    invalid_param!(:siren_or_siret_or_rna)
  end

  private

  def rna_id
    @rna_id ||= RNAId.new(siren_or_siret_or_rna)
  end

  def siret
    @siret ||= Siret.new(siren_or_siret_or_rna)
  end

  def siren
    @siren ||= Siren.new(siren_or_siret_or_rna)
  end

  def siren_or_siret_or_rna
    context.params[:siren_or_siret_or_rna]
  end
end
