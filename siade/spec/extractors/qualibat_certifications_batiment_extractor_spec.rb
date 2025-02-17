RSpec.describe QUALIBATCertificationsBatimentExtractor, type: :extractor do
  describe '#perform' do
    subject(:extract) { described_class.new(pdf_content).perform }

    let(:pdf_content) { Rails.root.join(pdf_path).read }
    let(:pdf_path) { "spec/fixtures/pdfs/qualibat_certifications_batiment/#{filename}.pdf" }

    context 'with valid files' do
      YAML.load(ERB.new(Rails.root.join('spec/support/qualibat_certifications_batiment_extractor_tests.yml.erb').read).result(binding), permitted_classes: [Date, Symbol]).each do |test|
        context test[:name].to_s do
          let(:filename) { test[:filename] }

          it { is_expected.to eq(test[:data]) }
        end
      end

      %w[
        certifications_2_pages_rge_4e_page
        certifications_2_pages_with_annexes
        certifications_and_special_page
        certifications_2_pages_rge_2_pages
      ].each do |kind|
        describe "#{kind} validity" do
          let(:filename) { kind }

          it do
            expect {
              extract
            }.not_to raise_error
          end
        end
      end
    end

    context 'with invalid files' do
      %i[
        amiante
        permeabilite_air
        metallerie_feu
        reseaux_aerauliques
        traitement_bois
        cordistes
        verification_mesures_systemes_ventilation
      ].each do |kind|
        context "when it is a '#{kind.to_s.humanize}' certificate, which does not have the same format and not all certifications" do
          let(:filename) { kind }

          it do
            expect {
              extract
            }.to raise_error(QUALIBATCertificationsBatimentExtractor::PDFNotSupported)
          end

          it 'specifies the error' do
            extract
          rescue QUALIBATCertificationsBatimentExtractor::PDFNotSupported => e
            expect(e.kind).to eq(kind)
          end
        end
      end

      context 'with attestation which does not look like a QUALIBAT certification' do
        let(:filename) { 'strange_attestation' }

        it 'raises an InvalidFile error' do
          expect {
            extract
          }.to raise_error(QUALIBATCertificationsBatimentExtractor::InvalidFile)
        end
      end
    end
  end
end
