RSpec.describe 'Ping routes' do
  subject(:ping) do
    get route
  end

  shared_context 'with ping driver mocks' do |ping_config|
    before do
      case ping_config[:kind]
      when 'retriever', 'retriever_payload'
        allow(ping_driver.send(:retriever)).to receive(:call).and_return(
          Interactor::Context.new
        )
      when 'make_request'
        allow(ping_driver.send(:make_request)).to receive(:call).and_return(
          Interactor::Context.new(
            response: OpenStruct.new(
              code: ping_driver.send(:status_to_check)
            )
          )
        )

        if ping_driver.send(:token_interactor)
          allow(ping_driver.send(:token_interactor)).to receive(:call).and_return(
            Interactor::Context.new(
              token: 'token'
            )
          )
        end
      end
    end
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

    describe 'pings index' do
      subject(:get_pings) { get '/pings' }

      it 'renders 200 with an array of ping name/url' do
        get_pings

        expect(response).to have_http_status(:ok)

        data = response.parsed_body

        expect(data).to be_an(Array)
        expect(data.first.keys).to include('name', 'url')
      end
    end

    describe 'provider specific ping' do
      describe 'with valid providers' do
        Rails.application.config_for('pings')['api_entreprise'].each do |provider, config|
          ping_service = PingService.new('api_entreprise', provider)

          describe "/ping/#{provider}" do
            let(:route) { "/ping/#{provider}" }
            let(:ping_driver) { ping_service.send(:ping_driver).new(config.fetch(:driver_params)) }

            include_context 'with ping driver mocks', config

            it 'renders 200 or 502' do
              ping

              expect(response.status).to be_in([200, 502])
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

      describe 'in staging' do
        before do
          allow(Rails.env).to receive(:staging?).and_return(true)
        end

        context 'with valid provider' do
          let(:route) { '/ping/insee/sirene' }

          it 'renders 200' do
            ping

            expect(response).to have_http_status(:ok)
          end
        end

        context 'with invalid provider' do
          let(:route) { '/api/invalid_provider/ping' }

          it 'renders 404' do
            ping

            expect(response).to have_http_status(:not_found)
          end
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

    describe 'pings index' do
      subject(:get_pings) { get '/api/pings' }

      it 'renders 200 with an array of ping name/url' do
        get_pings

        expect(response).to have_http_status(:ok)

        data = response.parsed_body

        expect(data).to be_an(Array)
        expect(data.first.keys).to include('name', 'url')
      end
    end

    describe 'provider specific ping' do
      describe 'with valid providers' do
        Rails.application.config_for('pings')['api_particulier'].each do |provider, config|
          ping_service = PingService.new('api_particulier', provider)

          describe "/api/#{provider}/ping" do
            let(:route) { "/api/#{provider}/ping" }
            let(:ping_driver) { ping_service.send(:ping_driver).new(config.fetch(:driver_params)) }

            include_context 'with ping driver mocks', config

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

      describe 'in staging' do
        before do
          allow(Rails.env).to receive(:staging?).and_return(true)
        end

        context 'with valid provider' do
          let(:route) { '/api/caf/ping' }

          it 'renders 200' do
            ping

            expect(response).to have_http_status(:ok)
          end
        end

        context 'with invalid provider' do
          let(:route) { '/invalid_provider' }

          it 'renders 404' do
            ping

            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
