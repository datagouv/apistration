class APIParticulier::V2::CNAF::ComplementaireSanteSolidaireController < APIParticulier::V2::CNAF::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnaf_complementaire_sante_solidaire'
  end

  def retriever
    ::CNAF::ComplementaireSanteSolidaire
  end
end
