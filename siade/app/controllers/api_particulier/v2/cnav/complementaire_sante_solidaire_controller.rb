class APIParticulier::V2::CNAV::ComplementaireSanteSolidaireController < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_complementaire_sante_solidaire'
  end

  def retriever
    ::CNAV::ComplementaireSanteSolidaire
  end
end
