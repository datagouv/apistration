class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::RequiresFranceConnect

  nomenclature organizers: { 3 => ::CNOUS::StudentScholarshipWithFranceConnect, 4 => ::CNOUS::StudentScholarshipWithFranceConnect, 5 => ::CNOUS::StudentScholarshipWithFranceConnect }

  private

  def organizer_params
    civility_parameters_from_france_connect.merge(
      token_id: current_user.token_id,
      campaign_year: params[:campaignYear]
    )
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end

  def organizer
    @organizer ||= retrieve_payload_data(CNOUS::StudentScholarshipWithFranceConnect)
  end
end
