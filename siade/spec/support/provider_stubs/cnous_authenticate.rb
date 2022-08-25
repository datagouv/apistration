require_relative '../provider_stubs'

module ProviderStubs::CNOUSAuthenticate
  def mock_cnous_authenticate
    stub_cnous_authenticate_interactor

    stub_request(:post, /#{Siade.credentials[:cnous_authenticate_url]}/).to_return(
      status: 200,
      headers: { Authorization: 'Bearer valid_bearer' }
    )
  end

  private

  def stub_cnous_authenticate_interactor
    dbl_authenticate = instance_double(CNOUS::Authenticate).as_null_object
    allow(CNOUS::Authenticate).to receive(:new).and_return(dbl_authenticate)

    allow(dbl_authenticate).to receive(:decoded_jwt).with('valid_bearer').and_return([{ 'exp' => Time.zone.now.to_i + 100 }])
  end
end
