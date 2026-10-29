class APIEntreprise::V3AndMore::Infogreffe::ExtraitsRCSController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::Infogreffe::ExtraitsRCS }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::Infogreffe::ExtraitsRCSSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::Infogreffe::ExtraitsRCS)
  end
end
