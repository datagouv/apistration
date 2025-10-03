RSpec.describe ACOSS::AttestationsSociales, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:, recipient:) }

    let(:recipient) { valid_siret }
    let(:params) do
      {
        siren:,
        user_id: '1'
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'acoss/with_valid_siren' } do
      let(:siren) { valid_siren(:acoss) }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end

      its(:errors) { is_expected.to be_blank }

      its(:cacheable) { is_expected.to be(true) }

      it 'has a document_url key on resource' do
        expect(subject.bundled_data.data.document_url).to be_present
      end
    end

    context 'with invalid siren', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
      let(:siren) { not_found_siren }

      it { is_expected.to be_a_failure }

      it 'does not retrieve the resource' do
        resource = subject.bundled_data

        expect(resource).to be_blank
      end

      its(:errors) { is_expected.to be_present }

      its(:cacheable) { is_expected.to be(false) }
    end
  end
end
