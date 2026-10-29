class APIEntreprise::V3AndMore::INSEE::EtablissementsController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::Etablissement, 4 => ::INSEE::Etablissement }

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
    @organizer ||= retrieve_payload_data(::INSEE::Etablissement)
  end
end
