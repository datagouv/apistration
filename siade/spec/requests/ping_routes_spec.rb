RSpec.describe 'Ping routes', type: :request do
  subject(:ping) do
    get route
  end

  describe 'API entreprise' do
    before do
      host! 'entreprise.api.localtest.me'
    end

    context 'with v2' do
      let(:route) { '/v2/ping' }

      it 'works' do
        ping

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with v3' do
      let(:route) { '/v3/ping' }

      it 'works' do
        ping

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'API particulier' do
    before do
      host! 'particulier.api.localtest.me'
    end

    describe '/ping' do
      let(:route) { '/api/ping' }

      it 'works' do
        ping

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'provider specific ping' do
      let!(:stubbed_provider_call) do
        stub_request(:get, "https://particulier.api.gouv.fr#{path_tested}").to_return(
          status: 200
        )
      end

      describe '/api/caf/ping' do
        let(:route) { '/api/caf/ping' }
        let(:path_tested) { "/api/v2/composition-familiale?codePostal=#{code_postal}&numeroAllocataire=#{numero_allocataire}" }

        let(:code_postal) { Siade.credentials['ping_cnaf_postal_code'] }
        let(:numero_allocataire) { Siade.credentials['ping_cnaf_numero_allocataire'] }

        it 'works' do
          ping

          expect(response).to have_http_status(:ok)
        end

        it 'calls cnaf endpoint' do
          ping

          expect(stubbed_provider_call).to have_been_requested
        end
      end

      describe '/api/impots/ping' do
        let(:route) { '/api/impots/ping' }
        let(:path_tested) { "/api/v2/avis-imposition?numeroFiscal=#{numero_fiscal}&referenceAvis=#{reference_avis}" }

        let(:numero_fiscal) { Siade.credentials['ping_dgfip_svair_numero_fiscal'] }
        let(:reference_avis) { Siade.credentials['ping_dgfip_svair_reference_avis'] }

        it 'works' do
          ping

          expect(response).to have_http_status(:ok)
        end

        it 'calls dgfip svair endpoint' do
          ping

          expect(stubbed_provider_call).to have_been_requested
        end
      end
    end
  end
end
