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

    describe 'provider specific ping' do
      describe 'with valid providers' do
        Rails.application.config_for('pings')['api_entreprise'].each do |provider, config|
          ping_service = PingService.new('api_entreprise', provider)

          describe "/ping/#{provider}" do
            let(:route) { "/ping/#{provider}" }
            let(:ping_driver) { ping_service.send(:ping_driver).new(config.fetch(:driver_params)) }

            case config[:kind]
            when 'retriever'
              before do
                allow(retriever_tested).to receive(:call).and_return(
                  Interactor::Context.new
                )
              end

              let(:retriever_tested) { ping_driver.send(:retriever) }
              let(:params_tested) { ping_driver.send(:retriever_params) }
            when 'access_logs'
              before do
                AccessLog.create!(
                  route: ping_driver.send(:routes).sample,
                  status: '200',
                  timestamp: 1.minute.ago
                )
              end

              after do
                AccessLog.delete_all
              end
            end

            it 'renders 200' do
              ping

              expect(response).to have_http_status(:ok)
            end
          end
        end
      end

      describe 'with invalid provider' do
        let(:route) { '/api/invalid_provider/ping' }

        it 'renders 404' do
          ping

          expect(response).to have_http_status(:not_found)
        end
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

        Rails.application.config_for('pings')['api_particulier'].each do |provider, config|
          ping_service = PingService.new('api_particulier', provider)

          describe "/api/#{provider}/ping" do
            let(:route) { "/api/#{provider}/ping" }
            let(:ping_driver) { ping_service.send(:ping_driver).new(config.fetch(:driver_params)) }

            let(:retriever_tested) { ping_driver.send(:retriever) }
            let(:params_tested) { ping_driver.send(:retriever_params) }

            it 'renders 200' do
              ping

              expect(response).to have_http_status(:ok)
            end

            it 'calls valid retriever with params' do
              ping

              expect(retriever_tested).to have_received(:call).with(hash_including(params: params_tested))
            end
          end
        end
      end

      describe 'with invalid provider' do
        let(:route) { '/api/invalid_provider/ping' }

        it 'renders 404' do
          ping

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
