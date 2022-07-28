class APIEntreprise::V2::CotisationsMSAController < APIEntreprise::V2::BaseController
  def show
    authorize :msa_cotisations

    cotisation = SIADE::V2::Retrievers::CotisationsMSA.new(siret_from_params)

    cotisation.retrieve

    if cotisation.success?
      render json: {
        analyse_en_cours: cotisation.analyse_en_cours?,
        a_jour: cotisation.a_jour?
      }, status: cotisation.http_code
    else
      render_errors(cotisation)
    end
  end

  def siret_from_params
    params.require(:siret)
  end
end
