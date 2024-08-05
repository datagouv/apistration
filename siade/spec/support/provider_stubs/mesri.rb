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
end
