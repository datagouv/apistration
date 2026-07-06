RSpec.describe ANTS::ExtraitImmatriculationVehicule, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_particulier_v3_ants_extrait_immatriculation_vehicule_with_france_connect', recipient: '13002526500013') }

  let(:params) do
    {
      immatriculation:,
      nom_naissance:,
      prenoms:,
      request_id: 'req-123'
    }
  end

  let(:immatriculation) { 'TT-939-WA' }
  let(:nom_naissance) { 'DUPONT' }
  let(:prenoms) { %w[JEAN] }

  describe 'valid params' do
    before do
      stub_ants_extrait_immatriculation_vehicule_valid
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  describe 'with a binary ASCII-8BIT response' do
    before do
      stub_ants_authenticate

      stub_request(:post, Siade.credentials[:ants_siv2_url]).to_return(
        status: 200,
        body: read_payload_file('ants/found.json').force_encoding('ASCII-8BIT')
      )
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  describe 'when the immatriculation is not found' do
    before do
      stub_ants_extrait_immatriculation_vehicule_not_found
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  describe 'when the identity does not match' do
    before do
      stub_ants_extrait_immatriculation_vehicule_identity_mismatch
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
