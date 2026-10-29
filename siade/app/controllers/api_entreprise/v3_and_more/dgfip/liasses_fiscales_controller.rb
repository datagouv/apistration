class APIEntreprise::V3AndMore::DGFIP::LiassesFiscalesController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::CommonDGFIPOrganizerParams

  nomenclature organizers: { 3 => ::DGFIP::LiassesFiscales, 4 => ::DGFIP::LiassesFiscales }

  private

  def organizer_params
    common_dgfip_organizer_params.merge(
      siren: params[:siren],
      year: params[:year]
    )
  end

  def serializer_module
    ::APIEntreprise::DGFIP::LiassesFiscalesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DGFIP::LiassesFiscales, cache: true)
  end
end
