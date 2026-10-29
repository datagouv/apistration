class APIEntreprise::V3AndMore::INSEE::SuccessionsController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::Successions }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::SuccessionsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::Successions)
  end
end
