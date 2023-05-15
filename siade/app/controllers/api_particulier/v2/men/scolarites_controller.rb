class APIParticulier::V2::MEN::ScolaritesController < APIParticulierController
  def show
    organizer = retrieve_payload_data(::MEN::Scolarites)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      family_name: params[:nom],
      first_name: params[:prenom],
      gender: params[:sexe],
      birth_date: params[:dateNaissance],
      code_etablissement: params[:codeEtablissement],
      annee_scolaire: params[:anneeScolaire]
    }
  end

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Student not found',
      message: error.detail
    }
  end
end
