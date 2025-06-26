RSpec.describe CNOUS::StudentScholarshipWithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:) }

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
  let(:prenoms) { %w[Jean Charlie] }
  let(:annee_date_naissance) { '2000' }
  let(:mois_date_naissance) { '01' }
  let(:jour_date_naissance) { '02' }
  let(:code_cog_insee_commune_naissance) { 'Angers' }
  let(:sexe_etat_civil) { 'm' }

  let(:token) { 'dummy_oauth_token' }

  it_behaves_like 'a make request with working mocking_params'

  context 'with all params' do
    let!(:stubbed_request) do
      stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).with(
        body: {
          lastName: 'Dupont',
          firstNames: 'Jean, Charlie',
          birthDate: '02/01/2000',
          birthPlace: 'Angers',
          civility: 'M'
        }.to_json,
        headers: {
          'Authorization' => "Bearer #{token}"
        }
      ).to_return(
        status: 200,
        body: cnous_valid_payload('civility').to_json
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'without code cog insee commune de naissance' do
    let(:code_cog_insee_commune_naissance) { nil }

    before do
      stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).with(
        body: {
          lastName: 'Dupont',
          firstNames: 'Jean, Charlie',
          birthDate: '02/01/2000',
          civility: 'M'
        }.to_json,
        headers: {
          'Authorization' => "Bearer #{token}"
        }
      ).to_return(
        status: 200,
        body: cnous_valid_payload('civility').to_json
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
