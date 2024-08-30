class APIParticulier::V3AndMore::CNAV::QuotientFamilialWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::QuotientFamilialV2
  end

  def serializer_module
    ::APIParticulier::CNAV::QuotientFamilial
  end

  def organizer_params
    super.merge({ mois: params[:mois], annee: params[:annee] })
  end
end
