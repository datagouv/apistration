class APIParticulier::V3AndMore::MEN::ScolaritesWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable
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

  def organizer_params
    civility_parameters_from_france_connect(except: %i[
      nom_usage
      code_cog_insee_commune_de_naissance
      code_pays_lieu_de_naissance
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
