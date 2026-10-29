class APIParticulier::V3AndMore::MEN::ScolaritesWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::MEN::Scolarites, 4 => ::MEN::Scolarites, 5 => ::MEN::Scolarites }

  private

  def organizer_params
    civility_parameters
      .merge({
        annee_scolaire: params[:anneeScolaire],
        code_etablissement: params[:codeEtablissement],
        degre_etablissement: params[:degreEtablissement],
        codes_bcn_departements: params[:codesBcnDepartements],
        codes_bcn_regions: params[:codesBcnRegions],
        provider_api_version: 'v2'
      })
  end

  def serializer_module
    ::APIParticulier::MEN::ScolaritesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MEN::Scolarites)
  end
end
