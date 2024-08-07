require_relative '../provider_stubs'

module ProviderStubs::MESRI
  def stub_mesri_valid
    stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 200,
      body: read_payload_file('mesri/statut_etudiant/valid.json')
    )
  end

  def stub_mesri_with_civility_valid
    stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 200,
      body: read_payload_file('mesri/statut_etudiant/valid.json')
    )
  end

  def stub_mesri_not_found
    stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 404,
      body: read_payload_file('mesri/statut_etudiant/not_found.json')
    )
  end

  def stub_mesri_with_civility_not_found
    stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
      status: 404,
      body: read_payload_file('mesri/statut_etudiant/not_found.json')
    )
  end
end
