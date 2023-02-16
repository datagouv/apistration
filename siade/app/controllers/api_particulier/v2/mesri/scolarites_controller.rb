class APIParticulier::V2::MESRI::ScolaritesController < APIParticulierController
  def show
    organizer = ::MESRI::Scolarites.call(params: organizer_params)

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
end
