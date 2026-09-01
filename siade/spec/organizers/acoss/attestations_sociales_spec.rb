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

    context 'with valid siren' do
      let(:siren) { valid_siren(:acoss) }

      before do
        mock_urssaf_authenticate

        mock_valid_urssaf_attestation_sociale do
          Base64.strict_encode64(Rails.root.join('spec/fixtures/pdfs/urssaf_attestations_sociales/basic.pdf').read)
        end
      end

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

    context 'with invalid siren' do
      let(:siren) { not_found_siren }

      before do
        mock_urssaf_authenticate

        mock_urssaf_attestation_sociale_not_found do
          [
            {
              'code' => 'FUNC517',
              'message' => 'Le Siren est inconnu',
              'description' => 'Le siren est inconnu du SI Attestations, radié ou hors périmètre'
            }
          ].to_json
        end
      end

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
