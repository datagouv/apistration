class API::V2::BilansEntreprisesBDFController < API::AuthenticateEntityController
  def show
    authorize :bilans_entreprise_bdf

    retrieve_bilans_bdf = SIADE::V2::Retrievers::BilansEntreprisesBDF.new(siren)

    retrieve_bilans_bdf.retrieve

    if retrieve_bilans_bdf.success?
      render json: BilansEntrepriseBDFSerializer.new(retrieve_bilans_bdf).as_json, status: retrieve_bilans_bdf.http_code
    else
      render_errors(retrieve_bilans_bdf)
    end
  end

  private

  def siren
    params.require(:siren)
  end
end
