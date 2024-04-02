class APIParticulier::V2::CNAF::PrimeActiviteController < APIParticulier::V2::CNAF::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnaf_prime_activite'
  end

  def retriever
    ::CNAF::PrimeActivite
  end
end
