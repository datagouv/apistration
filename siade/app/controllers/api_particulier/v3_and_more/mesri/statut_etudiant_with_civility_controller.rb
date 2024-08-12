class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithCivilityController < APIParticulier::V3AndMore::BaseController
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

  # rubocop:disable Metrics/AbcSize
  def organizer_params
<<<<<<< Updated upstream
    {
      family_name: params.require(:nomNaissance),
      first_name: params.require(:prenoms).first,
      birth_date: "#{params.require(:anneeDateDeNaissance)}-#{params.require(:moisDateDeNaissance)}-#{params.require(:jourDateDeNaissance)}",
      birth_place: params[:codeCogInseeCommuneDeNaissance],
      gender: params.require(:sexeEtatCivil).upcase,
      france_connect: true,
      token_id: current_user.token_id
    }
=======
    civility_parameters(required: %i[
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
      sexeEtatCivil
    ])
      .merge({ token_id: current_user.token_id })
>>>>>>> Stashed changes
  end
  # rubocop:enable Metrics/AbcSize

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end
end
