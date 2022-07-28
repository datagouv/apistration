class APIEntreprise::V2::EligibilitesCotisationRetraitePROBTPController < APIEntreprise::V2::BaseController
  def show
    authorize :probtp

    eligibility_cotisation_status_retriever = SIADE::V2::Retrievers::EligibilitesCotisationRetraitePROBTP.new(siret_from_params)

    eligibility_cotisation_status_retriever.retrieve

    if eligibility_cotisation_status_retriever.success?
      render json: {
        eligible: eligibility_cotisation_status_retriever.eligible?,
        message: eligibility_cotisation_status_retriever.message
      },
        status: eligibility_cotisation_status_retriever.http_code
    else
      render_errors(eligibility_cotisation_status_retriever)
    end
  end

  def siret_from_params
    params.require(:siret)
  end
end
