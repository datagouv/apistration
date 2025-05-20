RSpec.describe MI::Associations::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'MI', params:) }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    let(:params) { { siret_or_rna: 'super siret' } }

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
            '<id_correspondance>' \
            '1234567890' \
            '</id_correspondance>' \
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
              '<id_correspondance>' \
              '1234567890' \
              '</id_correspondance>' \
              '<regime>' \
              'autre' \
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
              '<id_correspondance>' \
              '1234567890' \
              '</id_correspondance>' \
              '<regime>' \
              'alsaceMoselle' \
              '</regime>' \
              '</identite>' \
              '</asso>'
          end

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end

        context 'when it is an asso before 2009 without any updates and thus without RNA ID' do
          let(:body) do
            '<asso>' \
              '<identite>' \
              '<id_correspondance>' \
              '1234567890' \
              '</id_correspondance>' \
              '<regime>' \
              'loi1901' \
              '</regime>' \
              '<id_forme_juridique>' \
              "#{code_asso}" \
              '</id_forme_juridique>' \
              '</identite>' \
              '</asso>'
          end

          %w[9220 9230 9260].each do |code_asso|
            let(:code_asso) { code_asso }
            it { is_expected.to be_a_success }

            its(:errors) { is_expected.to be_empty }
          end
        end
      end

      context 'with a body contning NotFound message' do
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

    describe 'non regression test: error message not found' do
      let(:code) { '404' }

      let(:body) do
        '<asso>' \
          '<erreur>' \
          '<proxy_correspondance>' \
          'org.apache.camel.http.common.HttpOperationFailedException: HTTP operation failed invoking http://localhost:8181/services/proxy_db_asso/correspondance/idsByRna/W111111111 with statusCode: 404' \
          '</proxy_correspondance>' \
          '</erreur>' \
          '</asso>'
      end

      context 'when param is siret_or_rna' do
        its(:errors) { is_expected.to have_error("Le siret ou l'identifiant RNA indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.") }
      end

      context 'when param is siren_or_rna' do
        let(:params) { { siren_or_rna: 'super siren' } }

        its(:errors) { is_expected.to have_error("Le siren ou l'identifiant RNA indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.") }
      end
    end
  end
end
