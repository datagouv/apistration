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

    describe 'when the provider returns an internal server error' do
      let(:code) { '500' }
      let(:body) { 'internal server error' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    describe 'when the provider returns a not found error' do
      let(:code) { '404' }
      let(:body) { '{"message":"Rna W111111111 not found in rna"}' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    describe 'when the provider rejects the id as unacceptable' do
      let(:code) { '400' }
      let(:body) { %({"message":"W111111111 n'est pas reconnu comme un code acceptable"}) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with a body containing rna id' do
        let(:body) do
          { identite: { id_correspondance: 1_234_567_890, id_rna: valid_rna_id } }.to_json
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'with a body without rna id' do
        context 'when regime is not alsaceMoselle' do
          let(:body) do
            { identite: { id_correspondance: 1_234_567_890, regime: 'autre' } }.to_json
          end

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
        end

        context 'when regime is alsaceMoselle' do
          let(:body) do
            { identite: { id_correspondance: 1_234_567_890, regime: 'alsaceMoselle' } }.to_json
          end

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end

        context 'when it is an asso before 2009 without any updates and thus without RNA ID' do
          let(:body) do
            { identite: { id_correspondance: 1_234_567_890, regime: 'loi1901', id_forme_juridique: code_asso } }.to_json
          end

          %w[9220 9221 9222 9223 9224 9230 9260].each do |code|
            context "when forme juridique is #{code}" do
              let(:code_asso) { code }

              it { is_expected.to be_a_success }

              its(:errors) { is_expected.to be_empty }
            end
          end

          context 'when forme juridique is not an association (e.g. SCOP)' do
            let(:code_asso) { '5658' }

            it { is_expected.to be_a_failure }

            its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
          end
        end
      end

      context 'with an empty body' do
        let(:body) { '' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderTemporaryError)) }
      end

      context 'with a body containing nonsense' do
        let(:body) { 'Nonsense' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end

      context 'with an unexpected JSON body' do
        let(:body) { '{"message":"internal error"}' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    describe 'not found error message' do
      let(:code) { '404' }
      let(:body) { '{"message":"Rna W111111111 not found in rna"}' }

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
