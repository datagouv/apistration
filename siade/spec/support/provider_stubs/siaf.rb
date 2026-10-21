require_relative '../provider_stubs'

module ProviderStubs::SIAF
  def stub_siaf_fondation(path: valid_rnf_id, status: 200, body: read_payload_file('mi/siaf/fondations/valid.json'))
    stub_request(:get, "#{Siade.credentials[:siaf_url]}/api/v1/fondations/#{path}")
      .with(headers: { 'Token' => Siade.credentials[:siaf_token] })
      .to_return(status:, body:)
  end

  def stub_siaf_fondation_not_found(path: non_existing_rnf_id)
    stub_siaf_fondation(path:, status: 404, body: read_payload_file('mi/siaf/fondations/not_found.json'))
  end
end
