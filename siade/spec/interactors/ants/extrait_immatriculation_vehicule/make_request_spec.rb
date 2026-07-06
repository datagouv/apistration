RSpec.describe ANTS::ExtraitImmatriculationVehicule::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:) }

    let(:token) { 'test_token' }
    let(:params) do
      {
        immatriculation: 'nm-257-nz',
        nom_naissance: 'Dupont',
        prenoms: ['Martin'],
        request_id: 'req-123'
      }
    end

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:ants_siv2_url])
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'X-Http-Method-Override' => 'GET',
            'Authorization' => 'Bearer test_token'
          },
          body: {
            informations: {
              numImmat: 'NM-257-NZ',
              nomNaiss: 'Dupont',
              prenom: 'Martin',
              numeroDemande: 'req-123'
            }
          }
        )
        .to_return(
          status: 200,
          body: { code: 0, libelle: 'Succès', listeDossiers: [] }.to_json
        )
    end

    it { is_expected.to be_a_success }

    it 'calls url with correct params' do
      subject

      expect(stubbed_request).to have_been_requested
    end
  end
end
