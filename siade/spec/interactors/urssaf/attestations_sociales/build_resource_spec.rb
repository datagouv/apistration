RSpec.describe URSSAF::AttestationsSociales::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(response:, url:) }

    let(:extractor) do
      instance_double(URSSAFAttestationVigilanceExtractor, perform: extractor_data)
    end
    let(:extractor_data) do
      {
        code_securite: 'QWERTYUIOIUYTRE',
        date_debut_validite: Date.new(2022, 12, 31)
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

      it 'builds valid resource' do
        expect(subject.bundled_data.data).to be_a(Resource)

        expect(subject.bundled_data.data.to_h).to include(
          entity_status_code: 'ok',
          document_url: url,
          date_debut_validite: Date.new(2022, 12, 31),
          date_fin_validite: Date.new(2023, 6, 30),
          code_securite: 'QWERTYUIOIUYTRE'
        )
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
