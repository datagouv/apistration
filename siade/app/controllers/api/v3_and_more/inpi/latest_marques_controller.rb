class API::V3AndMore::INPI::LatestMarquesController < API::V3AndMore::INPI::LatestOpenDataController
  def show
    organizer_klass = ::INPI::Marques

    call(organizer_klass)
  end

  private

  def serializer_module
    ::INPI::MarquesSerializer
  end
end
