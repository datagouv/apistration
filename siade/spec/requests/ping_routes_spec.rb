RSpec.describe 'Ping routes' do
  subject(:ping) do
    get route
  end

  describe 'API entreprise' do
    before do
      host! 'entreprise.api.localtest.me'
    end

    context 'with v2' do
      let(:route) { '/v2/ping' }

      it 'renders 200' do
        ping

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with v3' do
      let(:route) { '/v3/ping' }

      it 'renders 200' do
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

      it 'renders 200' do
        ping

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'provider specific ping' do
      describe 'with valid providers' do
        before do
          allow(retriever_tested).to receive(:call).and_return(
            Interactor::Context.new
          )
        end

        describe '/api/caf/ping' do
          let(:route) { '/api/caf/ping' }
          let(:retriever_tested) { CNAF::QuotientFamilial }
          let(:params_tested) do
            {
              beneficiary_number: Siade.credentials[:ping_cnaf_numero_allocataire],
              postal_code: Siade.credentials[:ping_cnaf_postal_code]
            }
          end

          it 'renders 200' do
            ping

            expect(response).to have_http_status(:ok)
          end

          it 'calls valid retriever with params' do
            ping

            expect(retriever_tested).to have_received(:call).with(params_tested)
          end
        end

        describe '/api/impots/ping' do
          let(:route) { '/api/impots/ping' }

          let(:retriever_tested) { DGFIP::SituationIR }
          let(:params_tested) do
            {
              tax_number: Siade.credentials[:ping_dgfip_svair_numero_fiscal],
              tax_notice_number: Siade.credentials[:ping_dgfip_svair_reference_avis]
            }
          end

          it 'renders 200' do
            ping

            expect(response).to have_http_status(:ok)
          end

          it 'calls valid retriever with params' do
            ping

            expect(retriever_tested).to have_received(:call).with(params_tested)
          end
        end
      end
    end
  end
end
