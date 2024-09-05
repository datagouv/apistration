class APIParticulier::V3AndMore::MEN::ScolaritesController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

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

  def transcogage?
    false
  end

  def organizer_params
    civility_parameters(requireds: %i[
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
      sexeEtatCivil
    ])
      .merge({
        annee_scolaire: params[:anneeScolaire],
        code_etablissement: params[:codeEtablissement]
      })
  end

  def serializer_module
    ::APIParticulier::MEN::ScolaritesSerializer
  end
end
