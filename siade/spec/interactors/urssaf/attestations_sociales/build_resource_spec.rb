RSpec.describe URSSAF::AttestationsSociales::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(response:, url:, params:) }

    let(:params) { { siren: '123456789' } }
    let(:extractor) do
      instance_double(URSSAFAttestationVigilanceExtractor, perform: extractor_data)
    end
    let(:extractor_data) do
      {
        code_securite: 'QWERTYUIOIUYTRE',
        date_debut_validite: Date.new(2022, 12, 3)
      }
    end

    before do
      allow(URSSAFAttestationVigilanceExtractor).to receive(:new).and_return(extractor)
    end

    describe 'when there is an url (valid document)' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
      let(:url) { 'https://entreprise.api.gouv.fr/file/attestation.pdf' }
      let(:body) { Base64.strict_encode64('body') }

      it { is_expected.to be_success }

      it 'calls extractor with decoded body' do
        subject

        expect(URSSAFAttestationVigilanceExtractor).to have_received(:new).with('body')
      end

      it 'builds valid resource, with date_fin_validite 6 months, at the end of the month, after the date_debut_validite' do
        expect(subject.bundled_data.data).to be_a(Resource)

        expect(subject.bundled_data.data.to_h).to include(
          entity_status_code: 'ok',
          document_url: url,
          date_debut_validite: Date.new(2022, 12, 3),
          date_fin_validite: Date.new(2023, 6, 30),
          code_securite: 'QWERTYUIOIUYTRE'
        )
      end

      it 'does not include extractor_error key' do
        expect(subject.bundled_data.data.to_h[:extractor_error]).to be_nil
      end
    end

    context 'when extractor raises InvalidFile' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
      let(:url) { 'https://entreprise.api.gouv.fr/file/attestation.pdf' }
      let(:body) { Base64.strict_encode64('invalid pdf content') }

      before do
        allow(extractor).to receive(:perform).and_raise(PDFExtractor::InvalidFile)
      end

      it { is_expected.to be_success }

      it 'builds resource with extractor_error and without extraction fields' do
        data = subject.bundled_data.data.to_h

        expect(data).to include(
          entity_status_code: 'ok',
          document_url: url,
          date_debut_validite: nil,
          date_fin_validite: nil,
          code_securite: nil,
          extractor_error: 'invalid_file'
        )
      end

      it 'keeps serializer fields available' do
        expect(subject.bundled_data.data.date_debut_validite).to be_nil
        expect(subject.bundled_data.data.date_fin_validite).to be_nil
        expect(subject.bundled_data.data.code_securite).to be_nil
      end

      it 'tracks the error with SIREN in context' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'info',
          '[URSSAF] PDF extraction failed',
          { siren: '123456789' }
        )

        subject
      end
    end

    context 'when there is no url, but a FUNC502' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
      let(:body) do
        [
          { code: 'FUNC502', message: 'Message 502', description: 'description' }
        ].to_json
      end
      let(:url) { nil }

      it { is_expected.to be_success }

      it 'builds valid resource' do
        expect(subject.bundled_data.data).to be_a(Resource)

        expect(subject.bundled_data.data.to_h).to include(
          entity_status_code: 'refus_de_delivrance',
          document_url: nil,
          date_debut_validite: nil,
          date_fin_validite: nil,
          code_securite: nil
        )
      end
    end
  end
end
