class APIParticulier::V2::CNAV::PrimeActiviteController < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_prime_activite'
  end

  def retriever
    ::CNAV::PrimeActivite
  end
end
