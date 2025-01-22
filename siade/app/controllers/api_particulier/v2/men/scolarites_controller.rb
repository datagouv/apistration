class APIParticulier::V2::MEN::ScolaritesController < APIParticulier::V2::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  # rubocop:disable Metrics/AbcSize
  def organizer_params
    {
      nom_naissance: params[:nom],
      prenoms: [params[:prenom]],
      annee_date_naissance: params[:dateNaissance].split('-').first,
      mois_date_naissance: params[:dateNaissance].split('-').second,
      jour_date_naissance: params[:dateNaissance].split('-').third,
      sexe_etat_civil: params[:sexe],
      code_etablissement: params[:codeEtablissement],
      annee_scolaire: params[:anneeScolaire],
      provider_api_version:
    }
  end
  # rubocop:enable Metrics/AbcSize

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Student not found',
      message: error.detail
    }
  end

  def provider_api_version
    return 'v1' if user_has_bourse_scope?

    'v2'
  end

  def user_has_bourse_scope?
    current_user.has_access?('men_statut_boursier') || current_user.has_access?('men_echelon_bourse')
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MEN::Scolarites)
  end
end
