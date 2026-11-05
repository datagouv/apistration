RSpec.describe 'Throttle override', api: :entreprise do
  before { Rack::Attack.reset! }
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  def override_throttle(throttle_overrides)
    AuthorizationRequestSecuritySettings.create!(authorization_request:, throttle_overrides:)
  end

  def get_times(count)
    count.times { get url, headers: headers_params }
  end

  let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234') }
  let(:token_record) do
    Token.create!(
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i,
      scopes: Scope.all,
      authorization_request_model_id: authorization_request.id
    )
  end
  let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }
  let(:headers_params) { { 'Authorization' => "Bearer #{jwt}" } }
  let(:url) { extract_without_context_url_for(**endpoint, only_path: true) }

  describe 'on json_resources_entreprise, limited to 2 requests per 60 seconds in the test env' do
    let(:endpoint) do
      {
        controller: 'api_entreprise/v3_and_more/opqibi/certifications_ingenierie',
        api_version: 3,
        action: 'show',
        siren: '123456789'
      }
    end

    it 'throttles at the group limit without override' do
      get_times(3)

      expect(response).to have_http_status(:too_many_requests)
    end

    context 'with an override of 5 requests per 60 seconds' do
      before { override_throttle('json_resources_entreprise' => { 'limit' => 5, 'period' => 60 }) }

      it 'allows requests up to the overridden limit' do
        5.times do
          get url, headers: headers_params
          expect(response).not_to have_http_status(:too_many_requests)
        end
      end

      it 'throttles beyond the overridden limit' do
        get_times(6)

        expect(response).to have_http_status(:too_many_requests)
      end
    end

    context 'with an override whose period differs from the group period' do
      before { override_throttle('json_resources_entreprise' => { 'limit' => 3, 'period' => 1 }) }

      it 'counts requests over the override period, not the group period' do
        now = Time.zone.parse('2026-11-05 12:00:10')

        Timecop.freeze(now) do
          get_times(4)
          expect(response).to have_http_status(:too_many_requests)
        end

        Timecop.freeze(now + 1.second) do
          get url, headers: headers_params
          expect(response).not_to have_http_status(:too_many_requests)
          expect(response.headers['RateLimit-Limit']).to eq('3')
        end
      end
    end
  end

  describe 'on gip_mds, limited to 50 requests per 60 seconds' do
    let(:endpoint) do
      {
        controller: 'api_entreprise/v3_and_more/gip_mds/effectifs_annuels_entreprise',
        api_version: 3,
        action: 'show',
        siren: '123456789',
        year: '2024'
      }
    end

    shared_examples 'allows 100 requests per minute' do
      it 'announces a limit of 100 over a window of at most 60 seconds' do
        Timecop.freeze do
          get url, headers: headers_params

          expect(response.headers['RateLimit-Limit']).to eq('100')
          expect(response.headers['RateLimit-Reset'].to_i - Time.now.to_i).to be_between(1, 60)
        end
      end

      it 'throttles the 101st request of the minute' do
        Timecop.freeze do
          get_times(100)
          expect(response).not_to have_http_status(:too_many_requests)

          get url, headers: headers_params
          expect(response).to have_http_status(:too_many_requests)
        end
      end
    end

    context 'with the production override converted to { limit: 100, period: 60 }' do
      before { override_throttle('gip_mds' => { 'limit' => 100, 'period' => 60 }) }

      it_behaves_like 'allows 100 requests per minute'
    end

    context 'with the legacy bare override 100, still cached for up to an hour during the transition' do
      before { override_throttle('gip_mds' => 100) }

      it_behaves_like 'allows 100 requests per minute'
    end
  end
end
