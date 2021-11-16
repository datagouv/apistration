RSpec.describe SIADE::SelfHostedDocument::File::Generic do
  before(:all) do
    # Dummy file type implementing the generic interface for specs
    module ExampleFileType; end
    ExampleFileType::PNG = Class.new(described_class) do
      def file_extension
        'png'
      end
    end
  end

  context 'when the document has a valid file type' do
    before do
      allow_any_instance_of(SIADE::SelfHostedDocument::FormatValidator)
        .to receive(:valid?).and_return(true)
    end

    let(:file_label) { 'veryname' }
    let(:filename_with_extension) { 'veryname.png' }

    let(:hosted_doc) { ExampleFileType::PNG.new(file_label) }

    describe '#store_from_binary' do
      subject(:store!) { hosted_doc.store_from_binary(bin) }

      let(:bin) { 'very binary' }

      it 'calls the uploader component with the binary content' do
        expect(SIADE::SelfHostedDocument::Uploader)
          .to receive(:call).with(filename_with_extension, bin)

        store!
      end

      it 'asks the uploader for the file URL' do
        expect_any_instance_of(SIADE::SelfHostedDocument::Uploader)
          .to receive(:url)

        store!
        hosted_doc.url
      end

      its(:success?) { is_expected.to eq(true) }
    end

    describe '#store_from_base64' do
      let(:content) { 'hello' }

      context 'when data is a valid base64 encoded string' do
        subject(:store!) do
          encoded_content = Base64.strict_encode64(content)
          hosted_doc.store_from_base64(encoded_content)
        end

        it 'calls the uploader with the decoded content' do
          expect(SIADE::SelfHostedDocument::Uploader)
            .to receive(:call).with(filename_with_extension, content)

          store!
        end

        its(:success?) { is_expected.to eq(true) }
      end

      context 'when data is not a valid base64 encoded string' do
        subject(:store!) { hosted_doc.store_from_base64('THIS IS F@KE!') }

        it 'does not upload the content' do
          expect(SIADE::SelfHostedDocument::Uploader).not_to receive(:call)

          store!
        end

        its(:success?) { is_expected.to eq(false) }
        its(:errors) { is_expected.to include([:invalid_base64, 'Erreur lors du décodage : invalide Base64 format']) }
      end
    end

    describe '#store_from_url' do
      let(:doc_url) { 'https://random.com/get_doc' }

      context 'when nothing happen while downloading the document' do
        subject(:store!) do
          stub_request(:get, doc_url).to_return(status: 200, body: 'very content')
          hosted_doc.store_from_url(doc_url)
        end

        it 'calls the uploader with the downloaded content' do
          expect(SIADE::SelfHostedDocument::Uploader)
            .to receive(:call).with(filename_with_extension, 'very content')

          store!
        end

        its(:success?) { is_expected.to eq(true) }
      end

      context 'when a HTTP error occurs downloading the document' do
        subject(:store!) do
          stub_request(:get, doc_url).to_return(status: 404, body: 'Not found')
          hosted_doc.store_from_url(doc_url)
        end

        it 'does not upload the content' do
          expect(SIADE::SelfHostedDocument::Uploader).not_to receive(:call)

          store!
        end

        its(:success?) { is_expected.to eq(false) }
        its(:errors) { is_expected.to include([:http_error, 'Erreur lors de la récupération du document : status 404 with body \'Not found\'']) }
      end

      context 'when a timeout occurs downloading the document' do
        subject(:store!) do
          stub_request(:get, doc_url).to_timeout
          hosted_doc.store_from_url(doc_url)
        end

        it 'does not upload the content' do
          expect(SIADE::SelfHostedDocument::Uploader).not_to receive(:call)

          store!
        end

        its(:success?) { is_expected.to eq(false) }
        its(:errors) { is_expected.to include([:timeout_error, 'Temps d\'attente de téléchargement du document écoulé']) }
      end

      context 'when there is an OpenSSL error, but it works with no security check' do
        subject(:store!) do
          stub_request(:get, doc_url)
            .to_raise(OpenSSL::SSL::SSLError)
            .times(1)
            .then
            .to_return(status: 200, body: 'very content')

          hosted_doc.store_from_url(doc_url)
        end

        it 'logs warning' do
          expect(MonitoringService.instance).to receive(:track).with(
            'warning',
            anything,
            anything
          )

          store!
        end

        its(:success?) { is_expected.to eq(true) }
      end

      context 'when there is an unknown error' do
        subject(:store!) do
          stub_request(:get, doc_url)
            .to_raise('PANIK')

          hosted_doc.store_from_url(doc_url)
        end

        it 'raises an error' do
          expect {
            store!
          }.to raise_error(StandardError)
        end
      end
    end
  end

  context 'when the document has an invalid file type' do
    # Testing with binary source as there are no extra steps like
    # decoding or downloading the content
    subject(:store!) { hosted_doc.store_from_binary('WRONG') }

    before do
      allow_any_instance_of(SIADE::SelfHostedDocument::FormatValidator)
        .to receive(:valid?).and_return(false)
    end

    let(:hosted_doc) { ExampleFileType::PNG.new('label') }

    it 'does not upload the content' do
      expect(SIADE::SelfHostedDocument::Uploader).not_to receive(:call)

      store!
    end

    its(:success?) { is_expected.to eq(false) }
    its(:errors) { is_expected.to include([:invalid_extension, 'Le fichier n\'est pas au format `png` attendu.']) }
  end
end
