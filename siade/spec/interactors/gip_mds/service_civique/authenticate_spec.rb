RSpec.describe GIPMDS::ServiceCivique::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_request(:post, "#{Siade.credentials[:gip_mds_domain]}/token")
      .with(body: hash_including(client_id: Siade.credentials[:gip_mds_dade_client_id], client_secret: Siade.credentials[:gip_mds_dade_client_secret]))
      .and_return(status: 200, body: { access_token: 'dade_token', expires_in: 3600 }.to_json)

    stub_request(:post, "#{Siade.credentials[:gip_mds_domain]}/token")
      .with(body: hash_including(client_id: Siade.credentials[:gip_mds_client_id]))
      .and_return(status: 200, body: { access_token: 'effectifs_token', expires_in: 3600 }.to_json)
  end

  it { is_expected.to be_a_success }

  its(:token) { is_expected.to eq('dade_token') }

  it 'does not reuse the token cached for the Effectifs client' do
    GIPMDS::Authenticate.call

    expect(subject.token).to eq('dade_token')
  end
end
