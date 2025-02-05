require 'rails_helper'

RSpec.describe QUALIBAT::CertificationsBatiment::BuildResource do
  describe '.call' do
    subject(:build_resource) { described_class.call(url:, params:) }

    let(:params) do
      {
        siret: valid_siret(:qualibat),
        api_version: '4'
      }
    end

    let(:url) { 'https://www.qualibat.com/example.pdf' }
    let(:extractor) { instance_double(QUALIBATCertificationsBatimentExtractor) }

    before do
      allow(QUALIBATCertificationsBatimentExtractor).to receive(:new).and_return(extractor)
    end

    context 'when extractor renders data' do
      before do
        allow(extractor).to receive(:perform).and_return(
          YAML.load(ERB.new(Rails.root.join('spec/support/qualibat_certifications_batiment_extractor_tests.yml.erb').read).result(binding), permitted_classes: [Date, Symbol]).first[:data]
        )
      end

      it { is_expected.to be_a_success }

      it 'does not affect extractor_error key to ressource' do
        expect(build_resource.bundled_data.data.to_h[:extractor_error]).to be_nil
      end
    end

    context 'when extractor raises a PDFNotSupported error' do
      before do
        allow(extractor).to receive(:perform).and_raise(QUALIBATCertificationsBatimentExtractor::PDFNotSupported.new(:whatever))
      end

      it { is_expected.to be_a_success }

      it 'affects extractor_error key to ressource' do
        expect(build_resource.bundled_data.data.to_h[:extractor_error]).to eq('whatever_pdf_not_supported')
      end

      it 'tracks as an info this error' do
        expect(MonitoringService.instance).to receive(:track).with(
          :info,
          "[Qualibat] PDF 'whatever' not supported"
        )

        build_resource
      end
    end

    context 'when extractor raises an InvalidFile error' do
      before do
        allow(extractor).to receive(:perform).and_raise(PDFExtractor::InvalidFile)
      end

      it { is_expected.to be_a_success }

      it 'affects extractor_error key to ressource' do
        expect(build_resource.bundled_data.data.to_h[:extractor_error]).to eq('invalid_file')
      end

      it 'tracks as an error this error' do
        expect(MonitoringService.instance).to receive(:track).with(
          :error,
          '[Qualibat] PDF is not valid'
        )

        build_resource
      end
    end
  end
end
