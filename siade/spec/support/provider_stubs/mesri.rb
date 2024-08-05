require_relative '../provider_stubs'

module ProviderStubs::MESRI
  def stub_mesri_valid
    stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 200,
      body: read_payload_file('mesri/statut_etudiant/valid.json')
    )
  end

  def api_key
    Siade.credentials[:mesri_student_status_token_with_ine]
  end

  def stub_mesri_not_found
    stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 404,
      body: read_payload_file('mesri/statut_etudiant/not_found.json')
    )
  end
end
