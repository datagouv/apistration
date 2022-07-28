class APIEntreprise::V3AndMore::INPI::LatestMarquesController < APIEntreprise::V3AndMore::INPI::AbstractController
  def show
    organizer_klass = ::INPI::Marques

    call(organizer_klass)
  end

  private

  def serializer_module
    ::APIEntreprise::INPI::MarqueSerializer
  end
end
