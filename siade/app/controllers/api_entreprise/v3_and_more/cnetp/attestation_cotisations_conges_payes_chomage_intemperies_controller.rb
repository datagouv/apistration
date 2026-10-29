class APIEntreprise::V3AndMore::CNETP::AttestationCotisationsCongesPayesChomageIntemperiesController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::CNETP::AttestationCotisationsCongesPayesChomageIntemperies }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::CNETP::AttestationCotisationsCongesPayesChomageIntemperiesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::CNETP::AttestationCotisationsCongesPayesChomageIntemperies)
  end
end
