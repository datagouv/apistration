class APIParticulier::V3AndMore::CNAV::QuotientFamilialWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::QuotientFamilialV2 }

  private

  def organizer_class
    CNAV::QuotientFamilialV2
  end

  def serializer_module
    ::APIParticulier::CNAV::QuotientFamilial
  end

  def organizer_params
    super.merge({ mois: params[:mois], annee: params[:annee] })
  end

  def expires_in
    24.hours
  end
end
