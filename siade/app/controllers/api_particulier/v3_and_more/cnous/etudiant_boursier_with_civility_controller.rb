class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(CNOUS::StudentScholarshipWithCivility)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def transcogage?
    true
  end

  private

  def organizer_params
    civility_parameters(requireds: %i[
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
    ])
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end
end
