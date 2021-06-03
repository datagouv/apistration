RSpec.describe ACOSS::AttestationsSociales, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren,
        user_id: '1',
        recipient: '1',
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes } do
      let(:siren) { valid_siren(:acoss) }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
      its(:errors) { is_expected.to be_blank }

      it 'has a document_url key on resource' do
        expect(subject.resource.document_url).to be_present
      end
    end

    context 'with invalid siren', vcr: { cassette_name: 'acoss/with_non_existent_siren', match_requests_on: strict_match_vcr_requests_on_attributes } do
      let(:siren) { not_found_siren }

      it { is_expected.to be_a_failure }

      its(:resource) { is_expected.to be_blank }
      its(:errors) { is_expected.to be_present }
    end
  end
end
