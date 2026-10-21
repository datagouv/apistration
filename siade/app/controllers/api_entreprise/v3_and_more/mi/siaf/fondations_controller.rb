class APIEntreprise::V3AndMore::MI::SIAF::FondationsController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::MI::SIAF::Fondations }

  private

  def organizer_params
    {
      siren_or_siret_or_rnf: params.require(:siren_or_siret_or_rnf)
    }
  end

  def serializer_module
    ::APIEntreprise::MI::SIAF::FondationsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MI::SIAF::Fondations)
  end
end
