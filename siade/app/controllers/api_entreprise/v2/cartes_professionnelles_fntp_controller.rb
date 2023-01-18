class APIEntreprise::V2::CartesProfessionnellesFNTPController < APIEntreprise::V2::BaseController
  def show
    retrieve_carte_pro_fntp = SIADE::V2::Retrievers::CartesProfessionnellesFNTP.new(siren)

    retrieve_carte_pro_fntp.retrieve

    if retrieve_carte_pro_fntp.success?
      render json: { url: retrieve_carte_pro_fntp.document_url }, status: retrieve_carte_pro_fntp.http_code
    else
      render_errors(retrieve_carte_pro_fntp)
    end
  end

  private

  def siren
    params.require(:siren)
  end
end
