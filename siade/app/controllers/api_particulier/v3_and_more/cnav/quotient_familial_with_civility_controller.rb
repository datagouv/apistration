class APIParticulier::V3AndMore::CNAV::QuotientFamilialWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::QuotientFamilialV2
  end

  def serializer_module
    ::APIParticulier::CNAV::QuotientFamilial
  end

  def api_params
    civility_parameters.merge({ mois: params[:mois], annee: params[:annee] })
  end

  def expires_in
    24.hours
  end

  def transcogage?
    true
  end
end
