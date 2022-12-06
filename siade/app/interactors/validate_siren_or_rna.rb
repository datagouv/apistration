class ValidateSirenOrRNA < ValidateParamInteractor
  def call
    return if rna_id.valid? || siren.valid?

    invalid_param!(:siren_or_rna)
  end

  private

  def rna_id
    @rna_id ||= RNAId.new(siren_or_rna)
  end

  def siren
    @siren ||= Siren.new(siren_or_rna)
  end

  def siren_or_rna
    context.params[:siren_or_rna]
  end
end
