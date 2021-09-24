RSpec.describe MI::Associations::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response: response, provider_name: 'MI') }

    let(:response) do
      instance_double('Net::HTTPOK', code: code, body: body)
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
          '<nom>' \
          'A Name' \
          '</nom>' \
          '</identite>' \
          '</asso>'
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
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

    context 'with a valid code and a body containing nonsense' do
      let(:code) { '200' }
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
