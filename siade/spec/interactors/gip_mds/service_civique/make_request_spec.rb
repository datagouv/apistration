RSpec.describe GIPMDS::ServiceCivique::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:) }

  let(:token) { GIPMDS::Authenticate.call.token }

  let(:params) do
    {
      prenoms: %w[Jean Paul],
      nom_naissance: 'Dupont',
      jour_date_naissance: 1,
      mois_date_naissance: 10,
      annee_date_naissance: '2000'
    }
  end

  before do
    Timecop.freeze(Time.zone.local(2024, 6, 15, 10, 30, 0))
    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  it_behaves_like 'a make request with working mocking_params'

  context 'with valid civility params' do
    let!(:stubbed_request) do
      stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/contrats-generique").with(
        query: {
          nom: 'DUPONT',
          prenom: 'Jean',
          dateNaissance: '01102000',
          listeCodeNature: '89',
          dateDebutPeriode: 5.years.ago.to_date.strftime('%Y-%m-%d')
        },
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      ).and_return(status: 200)
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls endpoint with correct params' do
      subject

      expect(stubbed_request).to have_been_requested
    end
  end
end
