RSpec.describe Documents::RetrieveFromUrl do
  subject(:make_call!) { described_class.call(retrieve_params.merge(provider_name:)) }

  let(:provider_name) { 'INSEE' }

  let(:retrieve_params) do
    { content: source_doc_url }
  end

  let(:mock_monitoring) { instance_double('MonitoringService') }

  before do
    allow(mock_monitoring).to receive(:track)
    allow(MonitoringService).to receive(:instance).and_return(mock_monitoring)
  end

  describe '.call' do
    let(:source_doc_url) { 'https://random.com/get_doc' }

    context 'when the source server responds with an HTTP success' do
      before do
        stub_request(:get, source_doc_url)
          .to_return(
            status: 200,
            body: 'much doc content'
          )
      end

      it { is_expected.to be_success }

      its(:content) { is_expected.to eq('much doc content') }
    end

    context 'when the source server responds with an HTTP error' do
      before do
        stub_request(:get, source_doc_url)
          .to_return(
            status: 404,
            body: 'Not Found'
          )
      end

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Erreur lors de la récupération du document : status 404 with body \'Not Found\'') }
    end

    context 'when a timeout occurs downloading the document' do
      before { stub_request(:get, source_doc_url).to_timeout }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Temps d\'attente de téléchargement du document écoulé') }
    end

    context 'when the source URL is invalid' do
      let(:source_doc_url) { 'not an URL' }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('L\'URL source du document chez le fournisseur de données est invalide : bad URI(is not URI?): "not an URL".') }
    end

    context 'when there is a connection reset by peer error' do
      before { stub_request(:get, source_doc_url).to_raise(Errno::ECONNRESET) }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Erreur de connexion sur le server distant') }
    end

    context 'when there is an IO error' do
      before { stub_request(:get, source_doc_url).to_raise(IOError) }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Erreur de lecture sur le server distant') }
    end

    context 'when there is an OpenSSL error, but it works with no security check' do
      before do
        stub_request(:get, source_doc_url)
          .to_raise(OpenSSL::SSL::SSLError)
          .times(1)
          .then
          .to_return(status: 200, body: 'very content')
      end

      it { is_expected.to be_success }

      it 'logs warning' do
        make_call!

        expect(mock_monitoring).to have_received(:track).with(
          'warning',
          anything,
          anything
        )
      end
    end

    context 'when there is an unknown error' do
      before do
        stub_request(:get, source_doc_url)
          .to_raise('PANIK')
      end

      it { is_expected.to be_failure }
      its(:errors) { is_expected.to include(instance_of(UnknownError)) }

      it 'logs error' do
        make_call!

        expect(mock_monitoring).to have_received(:track).with(
          'error',
          anything,
          anything
        )
      end
    end
  end
end
