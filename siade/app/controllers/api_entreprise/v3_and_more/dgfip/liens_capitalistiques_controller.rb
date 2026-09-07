class APIEntreprise::V3AndMore::DGFIP::LiensCapitalistiquesController < APIEntreprise::V3AndMore::DGFIP::LiassesFiscalesController
  nomenclature organizers: { 3 => ::DGFIP::LiensCapitalistiques }

  def serializer_module
    ::APIEntreprise::DGFIP::LiensCapitalistiquesSerializer
  end

  private

  def organizer
    @organizer ||= retrieve_payload_data(::DGFIP::LiensCapitalistiques, cache: true)
  end
end
