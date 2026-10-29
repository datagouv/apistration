class APIParticulier::V3AndMore::FranceTravail::StatutWithIdentifiantController < APIParticulier::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::FranceTravail::Statut }

  private

  def organizer_params
    {
      identifiant: params[:identifiant],
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIParticulier::FranceTravail::StatutSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FranceTravail::Statut)
  end
end
