RSpec.describe MI::Associations::Documents::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'MI') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    describe 'with an invalid code' do
      let(:code) { '418' }
      let(:body) { 'A body' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a valid code and documents' do
      let(:code) { '200' }
      let(:body) do
        {
          identite: { id_correspondance: 1_234_567_890 },
          documents: {
            nbDocRna: 2,
            document_rna: [
              { id: 123, type: 'PIECE', annee: 2014, sous_type: 'DCR', even: 5_248_133, time: 1_418_807_656, url: 'https://fakeurl.lol/to/the/doc', lib_sous_type: 'Décret' },
              { id: 456, type: 'PIECE', annee: 2014, sous_type: 'STC', even: 5_248_133, time: 1_418_807_674, url: 'https://anotherfake.url/to/more/doc', lib_sous_type: 'Statuts' }
            ]
          }
        }.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a valid response but no documents' do
      let(:code) { '200' }
      let(:body) do
        { identite: { id_correspondance: 1_234_567_890 }, documents: { nbDocRna: 0 } }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when the association is not found' do
      let(:code) { '404' }
      let(:body) { '{"message":"Rna W111111111 not found in rna"}' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a 404 proxy error (No service was found)' do
      let(:code) { '404' }
      let(:body) { '<html><body>No service was found.</body></html>' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
    end

    context 'with a valid code and an empty body' do
      let(:code) { '200' }
      let(:body) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderTemporaryError)) }
    end

    context 'with a valid code and a body containing nonsense' do
      let(:code) { '200' }
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
