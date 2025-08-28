RSpec.describe SDH::StatutSportif::MakeRequest, type: :make_request do
  subject { described_class.call(params:, token:) }

  let(:params) do
    {
      identifiant: '123456789'
    }
  end

  let(:token) { 'super_sdh_access_token' }

  before do
    stub_sdh_statut_sportif_valid('123456789')
  end

  it { is_expected.to be_a_success }
end
