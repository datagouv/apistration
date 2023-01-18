class APIEntreprise::V2::BilansEntreprisesBDFController < APIEntreprise::V2::BaseController
  def show
    retrieve_bilans_bdf = SIADE::V2::Retrievers::BilansEntreprisesBDF.new(siren)

    retrieve_bilans_bdf.retrieve

    if retrieve_bilans_bdf.success?
      render json: APIEntreprise::BilansEntrepriseBDFSerializer.new(retrieve_bilans_bdf).as_json, status: retrieve_bilans_bdf.http_code
    else
      render_errors(retrieve_bilans_bdf)
    end
  end

  private

  def siren
    params.require(:siren)
  end
end
