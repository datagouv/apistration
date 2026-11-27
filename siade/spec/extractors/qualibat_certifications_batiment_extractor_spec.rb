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

    context 'when the first page has no insurance label' do
      let(:filename) { 'without_insurance_labels' }
      let(:empty_insurance) { { nom: nil, identifiant: nil } }

      before do
        allow(MonitoringService.instance).to receive(:track_with_added_context)
      end

      it 'returns the certifications with empty insurances' do
        expect(extract[:entity]).to include(
          assurance_responsabilite_travaux: empty_insurance,
          assurance_responsabilite_civile: empty_insurance,
          certifications: contain_exactly(
            hash_including(code: '5111'),
            hash_including(code: '5211')
          )
        )
      end

      it 'reports each missing insurance label' do
        extract

        expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
          :info,
          '[Qualibat] Insurance label not found',
          { insurance_label: 'Assurance Responsabilité Travaux' }
        )
        expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
          :info,
          '[Qualibat] Insurance label not found',
          { insurance_label: 'Assurance Responsabilité Civile' }
        )
      end
    end

    context 'when a certification code is missing from the nomenclature' do
      let(:filename) { 'one_page' }
      let(:nomenclature_without_code) { Tempfile.new(['nomenclature', '.json']) }

      before do
        nomenclature = JSON.parse(File.read(QUALIBATCertificationsBatiment::CertificationsExtractor::NOMENCLATURE_PATH))
        nomenclature_without_code.write(nomenclature.reject { |entry| entry['code'] == '5211' }.to_json)
        nomenclature_without_code.flush
        stub_const('QUALIBATCertificationsBatiment::CertificationsExtractor::NOMENCLATURE_PATH', nomenclature_without_code.path)
        allow(Sentry).to receive(:capture_message)
      end

      after { nomenclature_without_code.close! }

      it 'returns the certification with its code and without label' do
        expect(extract[:entity][:certifications]).to include(
          code: '5211',
          nom: nil,
          rge: false,
          date_attribution: Date.new(2020, 4, 3)
        )
      end

      it 'keeps the certifications known by the nomenclature' do
        expect(extract[:entity][:certifications].pluck(:code)).to eq(%w[5111 5211])
      end

      it 'reports the unknown code to complete the nomenclature' do
        extract

        expect(Sentry).to have_received(:capture_message).with(
          '[Qualibat] Certification code missing from nomenclature',
          level: 'warning',
          fingerprint: %w[qualibat-certification-code-missing-from-nomenclature 5211]
        )
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
