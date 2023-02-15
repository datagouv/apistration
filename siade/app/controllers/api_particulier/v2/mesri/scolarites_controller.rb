class APIParticulier::V2::MESRI::ScolaritesController < APIParticulierController
  def show
    organizer = ::MESRI::Scolarites.call(params: organizer_params)

    if organizer.success?
      render json: ::APIParticulier::MESRI::ScolaritesSerializer::V3.new(organizer.bundled_data).serializable_hash,
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
      birthday_date: params[:date_naissance],
      code_etablissement: params[:code_etablissement],
      annee_scolaire: params[:annee_scolaire]
    }
  end

  def serializer_module
    ::APIParticulier::MESRI::ScolaritesSerializer
  end
end
