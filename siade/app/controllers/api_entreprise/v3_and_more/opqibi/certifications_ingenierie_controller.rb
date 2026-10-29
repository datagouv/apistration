class APIEntreprise::V3AndMore::OPQIBI::CertificationsIngenierieController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::OPQIBI::CertificationsIngenierie }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::OPQIBI::CertificationsIngenierieSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::OPQIBI::CertificationsIngenierie)
  end
end
