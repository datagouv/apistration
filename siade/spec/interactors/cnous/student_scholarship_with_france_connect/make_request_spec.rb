RSpec.describe CNOUS::StudentScholarshipWithFranceConnect::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:, operation_id: 'api_particulier_v2_whatever') }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      sexe_etat_civil:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { %w[Jean Martin] }
  let(:annee_date_naissance) { 2000 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 2 }
  let(:code_cog_insee_commune_naissance) { 'Angers' }
  let(:sexe_etat_civil) { 'm' }

  let(:token) { 'dummy_oauth_token' }

  let!(:stubbed_request) do
    stub_request(:get, Siade.credentials[:cnous_student_scholarship_france_connect_url]).with(
      body: {
        given_name: 'Jean, Martin',
        family_name: 'Dupont',
        birthdate: '02/01/2000',
        gender: 'M',
        birthplace: 'Angers'
      }.to_json,
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200,
      body: cnous_valid_payload('france_connect').to_json
    )
  end

  it_behaves_like 'a make request with working mocking_params'

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end

  context 'when in staging' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
      allow(MockDataBackend).to receive(:get_response_for).with(
        'api_particulier_v2_whatever',
        hash_including(
          {
            given_name: 'jean, martin'
          }
        )
      ).and_return(cnous_valid_payload('france_connect'))
    end

    it { is_expected.to be_a_success }
  end
end
