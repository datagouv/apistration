class APIEntreprise::V3AndMore::INPI::LatestModelesController < APIEntreprise::V3AndMore::INPI::AbstractController
  def show
    organizer_klass = ::INPI::Modeles

    call(organizer_klass)
  end

  private

  def serializer_module
    ::APIEntreprise::INPI::ModeleSerializer
  end
end
