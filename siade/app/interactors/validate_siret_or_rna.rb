class ValidateSiretOrRNA < ValidateParamInteractor
  def call
    return if rna_id.valid? || siret.valid?

    invalid_param!(:siret_or_rna)
  end

  private

  def rna_id
    @rna_id ||= RNAId.new(siret_or_rna)
  end

  def siret
    @siret ||= Siret.new(siret_or_rna)
  end

  def siret_or_rna
    context.params[:siret_or_rna]
  end
end
