class APIEntreprise::V3AndMore::INPI::LatestBrevetsController < APIEntreprise::V3AndMore::INPI::AbstractController
  private

  def organizer_klass
    ::INPI::Brevets
  end

  def serializer_module
    ::APIEntreprise::INPI::BrevetSerializer
  end
end
