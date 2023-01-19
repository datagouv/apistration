class APIParticulier::V3AndMore::MESRI::ScolaritesController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :scolarite

    organizer = ::MESRI::Scolarites.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource).serializable_hash,
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
      gender:,
      birthday_date: params[:date_naissance],
      code_etablissement: params[:code_etablissement],
      annee_scolaire: params[:annee_scolaire]
    }
  end

  def serializer_module
    ::APIParticulier::MESRI::ScolaritesSerializer
  end

  def gender
    case params[:sexe]
    when 'M'
      1
    when 'F'
      2
    end
  end
end
