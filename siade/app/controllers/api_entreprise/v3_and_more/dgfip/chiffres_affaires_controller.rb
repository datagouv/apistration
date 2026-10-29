class APIEntreprise::V3AndMore::DGFIP::ChiffresAffairesController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::CommonDGFIPOrganizerParams

  nomenclature organizers: { 3 => ::DGFIP::ChiffresAffaires }

  private

  def organizer_params
    common_dgfip_organizer_params.merge(
      siret: params[:siret]
    )
  end

  def serializer_module
    ::APIEntreprise::DGFIP::ChiffresAffairesCollectionSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DGFIP::ChiffresAffaires, cache: true)
  end
end
