RSpec.describe CIBTP::AttestationsCotisationsChomageIntemperies, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'with valid siret' do
    let(:siret) { valid_siret }

    before do
      stub_cibtp_authenticate
      stub_cibtp_attestations_cotisations_chomage_intemperies_valid(siret:)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present

      expect(resource).to be_a(Resource)
    end
  end
end
