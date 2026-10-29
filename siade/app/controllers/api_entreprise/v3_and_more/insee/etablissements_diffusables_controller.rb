class APIEntreprise::V3AndMore::INSEE::EtablissementsDiffusablesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::EtablissementDiffusable, 4 => ::INSEE::EtablissementDiffusable }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::EtablissementSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::EtablissementDiffusable)
  end
end
