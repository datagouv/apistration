RSpec.describe URSSAF::AttestationsSociales, type: :retriever_organizer do
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

      it 'has a entity_status_code key on resource with valid value' do
        expect(subject.bundled_data.data.entity_status_code).to eq('ok')
      end

      it 'has a document_url key on resource' do
        expect(subject.bundled_data.data.document_url).to be_present
      end
    end

    context 'with siren whichs return a FUNC502 error' do
      let(:siren) { valid_siren(:acoss) }

      before do
        mock_urssaf_authenticate

        mock_valid_urssaf_attestation_sociale do
          [
            {
              'code' => 'FUNC502',
              'message' => 'La situation du compte ne permet pas de délivrer l’attestation demandée',
              'description' => 'La situation du compte ne permet pas de délivrer l’attestation demandée'
            }
          ].to_json
        end
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_blank }

      its(:cacheable) { is_expected.to be(true) }

      it 'has a entity_status_code key on resource with valid value' do
        expect(subject.bundled_data.data.entity_status_code).to eq('refus_de_delivrance')
      end

      it 'has a document_url key on resource which is nil' do
        expect(subject.bundled_data.data.document_url).to be_nil
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
