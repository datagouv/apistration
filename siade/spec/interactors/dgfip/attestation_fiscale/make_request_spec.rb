RSpec.describe DGFIP::AttestationFiscale::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(cookie: cookie, params: params) }

  let(:cookie) { 'cookie' }

  let(:params) do
    {
      siren: siren,
      user_id: user_id
    }
  end
  let(:siren) { valid_siren }
  let(:user_id) { yes_jwt_user.id }

  let(:sanitized_user_id) { valid_dgfip_user_id }

  let!(:stubbed_dgfip_request) do
    stub_request(:get, Siade.credentials[:dgfip_attestations_fiscales_url]).with(
      headers: {
        'Cookie' => cookie,
        'Accept' => 'application/pdf'
      },
      query: {
        siren: siren,
        userId: sanitized_user_id,
        groupeIS: 'NON',
        groupeTVA: 'NON'
      }
    ).and_return(
      status: 200
    )
  end

  it 'calls endpoint with valid params and cookie' do
    make_request

    expect(stubbed_dgfip_request).to have_been_requested
  end

  its(:response) { is_expected.to be_a(Net::HTTPOK) }
end
