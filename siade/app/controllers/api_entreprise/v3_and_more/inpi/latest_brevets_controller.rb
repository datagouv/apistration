class APIEntreprise::V3AndMore::INPI::LatestBrevetsController < APIEntreprise::V3AndMore::INPI::AbstractController
  def show
    organizer_klass = ::INPI::Brevets

    call(organizer_klass)
  end

  private

  def serializer_module
    ::APIEntreprise::INPI::BrevetSerializer
  end
end
