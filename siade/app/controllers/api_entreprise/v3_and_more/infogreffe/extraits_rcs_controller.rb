class APIEntreprise::V3AndMore::Infogreffe::ExtraitsRCSController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::Infogreffe::ExtraitsRCS, 4 => ::Infogreffe::ExtraitsRCSSchema14 }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::Infogreffe::ExtraitsRCSSerializer
  end

  def retrieve_organizer_based_on_version
    if api_version == 3
      ::Infogreffe::ExtraitsRCS
    else
      ::Infogreffe::ExtraitsRCSSchema14
    end
  end

  def organizer
    @organizer ||= retrieve_payload_data(retrieve_organizer_based_on_version)
  end
end
