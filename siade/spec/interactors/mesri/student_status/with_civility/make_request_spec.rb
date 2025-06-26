RSpec.describe MESRI::StudentStatus::WithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:annee_date_naissance) { 2000 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 1 }
  let(:sexe_etat_civil) { 'M' }
  let(:token_id) { SecureRandom.uuid }
  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      sexe_etat_civil:,
      token_id:
    }
  end

  it_behaves_like 'a make request with working mocking_params'

  context 'with a birth place empty' do
    let(:params) do
      {
        nom_naissance:,
        prenoms:,
        annee_date_naissance:,
        mois_date_naissance:,
        jour_date_naissance:,
        code_cog_insee_commune_naissance:,
        sexe_etat_civil:,
        token_id:
      }
    end

    let(:code_cog_insee_commune_naissance) { '' }

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:mesri_student_status_url]).with(
        body: {
          nomFamille: nom_naissance,
          prenom1: prenoms.first,
          dateNaissance: '2000-01-01',
          sexe: '1'
        }.to_json,
        headers: {
          'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_civility],
          'X-Caller' => "DINUM - #{token_id}"
        }
      ).to_return(
        status: 200,
        body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params, by removing empty code_cog_insee_commune_naissance place and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'without birth place' do
    let(:params) do
      {
        nom_naissance:,
        prenoms:,
        annee_date_naissance:,
        mois_date_naissance:,
        jour_date_naissance:,
        sexe_etat_civil:,
        token_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:mesri_student_status_url]).with(
        body: {
          nomFamille: nom_naissance,
          prenom1: prenoms.first,
          dateNaissance: '2000-01-01',
          sexe: '1'
        }.to_json,
        headers: {
          'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_civility],
          'X-Caller' => "DINUM - #{token_id}"
        }
      ).to_return(
        status: 200,
        body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end
end
