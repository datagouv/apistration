RSpec.describe QUALIBATCertificationsBatimentExtractor, type: :extractor do
  describe '#perform' do
    subject(:extract) { described_class.new(pdf_content).perform }

    let(:pdf_content) { Rails.root.join(pdf_path).read }
    let(:pdf_path) { "spec/fixtures/pdfs/qualibat_certifications_batiment/#{filename}.pdf" }

    context 'with valid files' do
      YAML.load(ERB.new(Rails.root.join('spec/support/qualibat_certifications_batiment_extractor_tests.yml.erb').read).result(binding), permitted_classes: [Date, Symbol]).each do |test|
        context "with #{test[:name]}" do
          let(:filename) { test[:filename] }

          it { is_expected.to eq(test[:data]) }
        end
      end
    end

    context 'with invalid files' do
      context 'when it is an amiante certificate, which does not have the same format and not all certifications' do
        let(:filename) { 'amiante' }

        it do
          expect {
            extract
          }.to raise_error(QUALIBATCertificationsBatimentExtractor::PDFNotSupported)
        end

        it 'specifies the error' do
          extract
        rescue QUALIBATCertificationsBatimentExtractor::PDFNotSupported => e
          expect(e.kind).to eq(:amiante)
        end
      end

      context 'when it is permeabilite air certificate, which does not have the same format and not all certifications' do
        let(:filename) { 'permeabilite_air' }

        it do
          expect {
            extract
          }.to raise_error(QUALIBATCertificationsBatimentExtractor::PDFNotSupported)
        end

        it 'specifies the error' do
          extract
        rescue QUALIBATCertificationsBatimentExtractor::PDFNotSupported => e
          expect(e.kind).to eq(:permeabilite_air)
        end
      end
    end
  end
end
