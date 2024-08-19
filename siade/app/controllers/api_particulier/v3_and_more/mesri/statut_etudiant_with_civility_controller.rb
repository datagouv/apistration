class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(MESRI::StudentStatus::WithCivility)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    civility_parameters(required: %i[
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
      sexeEtatCivil
    ])
      .merge({ token_id: current_user.token_id })
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end
end
