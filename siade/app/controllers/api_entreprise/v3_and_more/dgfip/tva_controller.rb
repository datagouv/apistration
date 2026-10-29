class APIEntreprise::V3AndMore::DGFIP::TVAController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::DGFIP::TVA }

  private

  def organizer_params
    { siren: params[:siren] }
  end

  def serializer_module
    ::APIEntreprise::DGFIP::NumeroTVASerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DGFIP::TVA, cache: true)
  end
end
