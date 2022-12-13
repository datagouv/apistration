RSpec.describe MI::Associations::ValidateResponse, type: :validate_response do
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

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with a body containing rna id' do
        let(:body) do
          '<asso>' \
            '<identite>' \
            '<nom>' \
            'A Name' \
            '</nom>' \
            "<id_rna>#{valid_rna_id}</id_rna>" \
            '</identite>' \
            '</asso>'
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'with a body without rna id' do
        context 'when regime is not alsaceMoselle' do
          let(:body) do
            '<asso>' \
              '<identite>' \
              '<nom>' \
              'A Name' \
              '</nom>' \
              '<regime>' \
              'loi1901' \
              '</regime>' \
              '</identite>' \
              '</asso>'
          end

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
        end

        context 'when regime is alsaceMoselle' do
          let(:body) do
            '<asso>' \
              '<identite>' \
              '<nom>' \
              'A Name' \
              '</nom>' \
              '<regime>' \
              'alsaceMoselle' \
              '</regime>' \
              '</identite>' \
              '</asso>'
          end

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end
      end

      context 'with a body containing NotFound message' do
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

      context 'with a body containing nonsense' do
        let(:code) { '200' }
        let(:body) { 'Nonsense' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end
  end
end
