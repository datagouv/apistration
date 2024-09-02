class APIParticulier::V2::CNAV::QuotientFamilialV2Controller < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_quotient_familial_v2'
  end

  def user_identity_params
    super.merge({
      annee: params[:annee],
      mois: params[:mois]
    })
  end

  def retriever
    ::CNAV::QuotientFamilialV2
  end

  def expires_in
    24.hours
  end

  def api_name
    'quotient_familial'
  end
end
