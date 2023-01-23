class APIEntreprise::V3AndMore::INPI::LatestMarquesController < APIEntreprise::V3AndMore::INPI::AbstractController
  private

  def organizer_klass
    ::INPI::Marques
  end

  def serializer_module
    ::APIEntreprise::INPI::MarqueSerializer
  end
end
