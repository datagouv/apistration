class APIParticulier::V3AndMore::FranceTravail::IndemnitesWithIdentifiantController < APIParticulier::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::FranceTravail::Indemnites }

  private

  def organizer_params
    {
      identifiant: params[:identifiant],
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIParticulier::FranceTravail::IndemnitesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FranceTravail::Indemnites)
  end
end
