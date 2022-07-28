class APIEntreprise::V2::EORIDouanesController < APIEntreprise::V2::BaseController
  def show
    authorize :eori_douanes

    retrieve_eori_douanes = SIADE::V2::Retrievers::EORIDouanes.new(eori)
    retrieve_eori_douanes.retrieve

    if retrieve_eori_douanes.success?
      render json: APIEntreprise::EORIDouanesSerializer.new(retrieve_eori_douanes).as_json, status: retrieve_eori_douanes.http_code
    else
      render_errors(retrieve_eori_douanes)
    end
  end

  private

  def eori
    if valid_siret?
      build_french_eori(siret_or_eori)
    else
      siret_or_eori
    end
  end

  def build_french_eori(siret)
    'FR' + siret
  end

  def valid_siret?
    Siret.new(siret_or_eori).valid?
  end

  def siret_or_eori
    params[:siret_or_eori]
  end
end
