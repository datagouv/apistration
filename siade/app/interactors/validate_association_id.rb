class ValidateAssociationId < ValidateParamInteractor
  def call
    return if rna_id.valid? || siret.valid?

    invalid_param!(:id)
  end

  private

  def rna_id
    @rna_id ||= RNAId.new(param(:id))
  end

  def siret
    @siret ||= Siret.new(param(:id))
  end

  def id
    context.params[:id]
  end
end
