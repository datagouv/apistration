class APIEntreprise::V3AndMore::INPI::RNE::BeneficiairesEffectifsController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::INPIRNECache

  nomenclature organizers: { 3 => ::INPI::RNE::BeneficiairesEffectifs }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INPI::RNE::BeneficiairesEffectifsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INPI::RNE::BeneficiairesEffectifs, cache: true, expires_in:)
  end
end
