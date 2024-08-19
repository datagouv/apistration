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

  def organizer_params
<<<<<<< Updated upstream
    {
      nom_naissance: params.require(:nomNaissance),
      prenoms: params.require(:prenoms),
      annee_date_de_naissance: params.require(:anneeDateDeNaissance),
      mois_date_de_naissance: params.require(:moisDateDeNaissance),
      jour_date_de_naissance: params.require(:jourDateDeNaissance),
      code_cog_insee_commune_de_naissance: params[:codeCogInseeCommuneDeNaissance],
      sexe_etat_civil: params.require(:sexeEtatCivil).upcase,
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

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end
end
