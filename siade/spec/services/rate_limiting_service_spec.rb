RSpec.describe RateLimitingService do
  let(:req) { instance_double(Rack::Request) }

  before do
    allow(req).to receive(:params).and_return({})
  end

  describe '#discriminate_by_jwt_for_endpoints' do
    subject { described_class.new.discriminate_by_jwt_for_endpoints(req, endpoints) }

    let(:endpoints) do
      [
        {
          controller: 'api_entreprise/v3_and_more/insee/etablissements',
          action: 'show'
        },
        {
          controller: 'api_entreprise/v3_and_more/insee/unites_legales',
          action: 'show'
        },
        {
          controller: 'api_entreprise/v3_and_more/dgfip/liasses_fiscales',
          action: 'show'
        }
      ]
    end

    let(:base_path) { 'http://entreprise.api.localtest.me' }

    before do
      allow(req).to receive(:url).and_return("#{base_path}/random/path")
      allow(req).to receive(:get_header).with('HTTP_X_API_KEY').and_return(nil)
    end

    context 'when authorization header is not set' do
      before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return(nil) }

      it { is_expected.to be_nil }
    end

    context 'when authorization header is set' do
      context 'when the Bearer format is not respected' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return('Beer hour') }

        it { is_expected.to be_nil }
      end

      context 'when the Bearer is well formed' do
        let(:token_value) { 'wow token' }

        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return("Bearer #{token_value}") }

        context 'when the request path matches one of the endpoint\'s URL in the list' do
          before { allow(req).to receive(:url).and_return("#{base_path}/v3/insee/sirene/etablissements/0001") }

          it { is_expected.to eq(Digest::SHA256.hexdigest(token_value)) }
        end

        describe 'non-regression test: when the request path matches dgfip v3 attestations_fiscales' do
          before { allow(req).to receive(:url).and_return("#{base_path}/v3/dgfip/unites_legales/301028346/liasses_fiscales/2017") }

          it { is_expected.to eq(Digest::SHA256.hexdigest(token_value)) }
        end

        context 'when the request path does not match any of the endpoints in the list' do
          before { allow(req).to receive(:url).and_return("#{base_path}/not/in/the/list") }

          it { is_expected.to be_nil }
        end
      end
    end
  end

  describe '#whitelisted_access?' do
    subject { described_class.new.whitelisted_access?(req) }

    before do
      allow(req).to receive(:get_header).with('HTTP_X_API_KEY').and_return(nil)
    end

    context 'when authorization header is not set' do
      before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return(nil) }

      it { is_expected.to be(false) }
    end

    context 'when authorization header is set' do
      context 'when the Bearer format is not respected' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return('Beer hour') }

        it { is_expected.to be(false) }
      end

      context 'when the Bearer is well formed' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return("Bearer #{token}") }

        context 'when the token is whitelisted' do
          let(:token) { Rails.configuration.jwt_whitelist.sample }

          it { is_expected.to be(true) }
        end

        context 'when the token is not whitelisted' do
          let(:token) { 'random token' }

          it { is_expected.to be(false) }
        end
      end
    end
  end

  describe '#blacklisted_access?' do
    subject { described_class.new.blacklisted_access?(req) }

    before do
      allow(req).to receive(:get_header).with('HTTP_X_API_KEY').and_return(nil)
    end

    context 'when authorization header is not set' do
      before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return(nil) }

      it { is_expected.to be(false) }
    end

    context 'when authorization header is set' do
      context 'when the Bearer format is not respected' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return('Beer hour') }

        it { is_expected.to be(false) }
      end

      context 'when the Bearer is well formed' do
        before { allow(req).to receive(:get_header).with('HTTP_AUTHORIZATION').and_return("Bearer #{token}") }

        context 'when the token is blacklisted' do
          context 'when it is a token from the database' do
            let(:token) { TokenFactory.new([]).valid(uid: Seeds.new.blacklisted_jwt_id) }

            it { is_expected.to be(true) }
          end
        end

        context 'when the token is not blacklisted' do
          let(:token) { 'random token' }

          it { is_expected.to be(false) }
        end
      end
    end
  end
end
