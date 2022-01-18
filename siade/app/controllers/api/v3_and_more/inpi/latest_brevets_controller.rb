class API::V3AndMore::INPI::LatestBrevetsController < API::V3AndMore::INPI::AbstractController
  def show
    organizer_klass = ::INPI::Brevets

    call(organizer_klass)
  end

  private

  def serializer_module
    ::INPI::BrevetsSerializer
  end
end
