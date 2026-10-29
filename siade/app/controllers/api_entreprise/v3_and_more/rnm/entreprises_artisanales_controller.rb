class APIEntreprise::V3AndMore::RNM::EntreprisesArtisanalesController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::RNM::EntreprisesArtisanales }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::RNM::EntrepriseArtisanaleSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::RNM::EntreprisesArtisanales)
  end
end
