RSpec.describe DGFIPAttestationFiscaleExtractor, type: :extractor do
  describe '#perform' do
    subject { described_class.new(pdf_content).perform }

    let(:pdf_content) { Rails.root.join(pdf_path).read }

    context 'with valid files' do
      let(:pdf_path) { "spec/fixtures/pdfs/dgfip_attestations_fiscales/#{kind}.pdf" }

      context 'with basic file' do
        let(:kind) { 'basic' }

        it do
          expect(subject).to eq(
            {
              valid: true
            }
          )
        end
      end

      context 'with not delivered file' do
        let(:kind) { 'not_delivered' }

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
end
