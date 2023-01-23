class APIEntreprise::V3AndMore::INPI::LatestModelesController < APIEntreprise::V3AndMore::INPI::AbstractController
  private

  def organizer_klass
    ::INPI::Modeles
  end

  def serializer_module
    ::APIEntreprise::INPI::ModeleSerializer
  end
end
