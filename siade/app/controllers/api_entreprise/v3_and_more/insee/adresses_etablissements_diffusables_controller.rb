class APIEntreprise::V3AndMore::INSEE::AdressesEtablissementsDiffusablesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::AdresseEtablissementDiffusable }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::AdresseEtablissementSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::AdresseEtablissementDiffusable)
  end
end
