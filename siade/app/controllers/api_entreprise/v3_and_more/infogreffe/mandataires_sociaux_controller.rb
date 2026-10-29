class APIEntreprise::V3AndMore::Infogreffe::MandatairesSociauxController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::Infogreffe::MandatairesSociaux }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::Infogreffe::MandatairesSociaux
  end

  def organizer
    @organizer ||= retrieve_payload_data(::Infogreffe::MandatairesSociaux)
  end
end
