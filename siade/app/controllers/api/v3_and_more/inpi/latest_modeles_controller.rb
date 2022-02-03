class API::V3AndMore::INPI::LatestModelesController < API::V3AndMore::INPI::AbstractController
  def show
    organizer_klass = ::INPI::Modeles

    call(organizer_klass)
  end

  private

  def serializer_module
    ::INPI::ModeleSerializer
  end
end
