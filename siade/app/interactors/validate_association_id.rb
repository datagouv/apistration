class ValidateAssociationId < ValidateParamInteractor
  def call
    return if rna_id_is_valid || siret_is_valid

    invalid_param!(:association_id)
  end

  private

  def rna_id_is_valid
    ::ValidateRNAId.call(params: { rna_id: id }).success?
  end

  def siret_is_valid
    ::ValidateSiret.call(params: { siret: id }).success?
  end

  def id
    context.params[:association_id]
  end
end
