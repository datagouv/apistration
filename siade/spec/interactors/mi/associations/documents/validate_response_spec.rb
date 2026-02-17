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

    context 'with a valid code and a valid xml' do
      let(:code) { '200' }
      let(:body) do
        '<asso>' \
          '<identite>' \
          '<id_correspondance>' \
          '1234567890' \
          '</id_correspondance>' \
          '</identite>' \
          '<documents>' \
          '<nbDocRna>' \
          '2' \
          '</nbDocRna>' \
          '<document_rna>' \
          '<id>123</id>' \
          '<type>PIECE</type>' \
          '<annee>2014</annee>' \
          '<sous_type>DCR</sous_type>' \
          '<even>5248133</even>' \
          '<time>1418807656</time>' \
          '<url>https://fakeurl.lol/to/the/doc</url>' \
          '<lib_sous_type>Décret</lib_sous_type>' \
          '</document_rna>' \
          '<document_rna>' \
          '<id>456</id>' \
          '<type>PIECE</type>' \
          '<annee>2014</annee>' \
          '<sous_type>STC</sous_type>' \
          '<even>5248133</even>' \
          '<time>1418807674</time>' \
          '<url>https://anotherfake.url/to/more/doc</url>' \
          '<lib_sous_type>Statuts</lib_sous_type>' \
          '</document_rna>' \
          '</documents>' \
          '</asso>'
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a valid response but no documents' do
      let(:code) { '200' }
      let(:body) do
        '<asso>' \
          '<identite>' \
          '<id_correspondance>' \
          '1234567890' \
          '</id_correspondance>' \
          '</identite>' \
          '<documents>' \
          '<nbDocRna>' \
          '0' \
          '</nbDocRna>' \
          '</documents>' \
          '</asso>'
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a valid code and a body containing NotFound message' do
      let(:code) { '200' }
      let(:body) do
        '<asso>' \
          '<erreur>' \
          '<proxy_correspondance>' \
          'org.apache.camel.http.common.HttpOperationFailedException: HTTP operation failed invoking http://localhost:8181/services/proxy_db_asso/correspondance/idsByRna/W111111111 with statusCode: 404' \
          '</proxy_correspondance>' \
          '</erreur>' \
          '</asso>'
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a 404 proxy error (No service was found)' do
      let(:code) { '404' }
      let(:body) { '<html><body>No service was found.</body></html>' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
    end

    context 'with a valid code and a body containing nonsense' do
      let(:code) { '200' }
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
