class APIParticulier::V3AndMore::CNAV::QuotientFamilialWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::QuotientFamilialV2 }

  def organizer_class
    CNAV::QuotientFamilialV2
  end

  def serializer_module
    ::APIParticulier::CNAV::QuotientFamilial
  end

  def api_params
    extra = params.permit(:mois, :annee)
    civility_parameters.merge(mois: extra[:mois], annee: extra[:annee])
  end

  def expires_in
    24.hours
  end
end
