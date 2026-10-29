class APIEntreprise::V3AndMore::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives }

  private

  def organizer_params
    {
      siret: params[:siret]
    }
  end

  def serializer_module
    ::APIEntreprise::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives)
  end
end
