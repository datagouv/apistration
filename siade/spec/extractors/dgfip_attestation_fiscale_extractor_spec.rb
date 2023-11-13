RSpec.describe DGFIPAttestationFiscaleExtractor, type: :extractor do
  describe '#perform' do
    subject { described_class.new(pdf_content).perform }

    let(:pdf_content) { Rails.root.join(pdf_path).read }

    context 'with valid files' do
      let(:pdf_path) { 'spec/support/dgfip_attestations_fiscales/basic.pdf' }

      it do
        expect(subject).to eq(
          {
            valid: true
          }
        )
      end
    end

    context 'with not delivered file' do
      let(:pdf_path) { 'spec/support/dgfip_attestations_fiscales/not_delivered.pdf' }

      it do
        expect(subject).to eq(
          {
            valid: false,
            error: :not_delivered
          }
        )
      end
    end
  end
end
