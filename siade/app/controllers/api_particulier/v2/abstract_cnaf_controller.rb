class APIParticulier::V2::AbstractCNAFController < APIParticulierController
  def show
    organizer = retrieve_payload_data(retriever)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def operation_id
    raise NotImplementedError
  end

  def retriever
    raise NotImplementedError
  end

  # rubocop:disable Metrics/AbcSize
  def organizer_params
    {
      nom_usage: params[:nomUsage],
      nom_naissance: params[:nomNaissance],
      prenoms: params[:prenoms],
      annee_date_de_naissance: params[:anneeDateDeNaissance],
      mois_date_de_naissance: params[:moisDateDeNaissance],
      jour_date_de_naissance: params[:jourDateDeNaissance],
      code_insee_lieu_de_naissance: params[:codeInseeLieuDeNaissance],
      code_pays_lieu_de_naissance: params.require(:codePaysLieuDeNaissance),
      gender: params.require(:sexe),
      annee: params[:annee],
      mois: params[:mois],
      user_siret: current_user.siret,
      request_id:
    }
  end
  # rubocop:enable Metrics/AbcSize

  def request_id
    request.request_id
  end
end
