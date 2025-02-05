RSpec.describe MonitoringService, type: :service do
  let(:instance) { described_class.instance }
  let(:provider) { 'dummy' }
  let(:scope) { instance_double(Sentry::Scope) }

  before do
    allow(Sentry).to receive(:with_scope).and_yield(scope)
    allow(scope).to receive(:set_context)

    instance.set_provider(provider)
  end

  after do
    Sentry.get_current_scope.clear
  end

  describe 'tracking methods' do
    describe '#track_provider_error' do
      subject { instance.track_provider_error(error) }

      let(:error) { ProviderInternalServerError.new('INSEE', 'PANIK') }
      let(:monitoring_private_context) do
        {
          oauth_token: 'very_secret'
        }
      end

      before do
        error.add_to_monitoring_private_context(monitoring_private_context)
      end

      it 'sets extra context with error payload, which returns json api error with all available informations' do
        expect(scope).to receive(:set_context).with(
          'Provider error',
          hash_including(
            error.to_h
          )
        )

        subject
      end

      it 'sets extra context with monitoring private context, which is not returned to users' do
        expect(scope).to receive(:set_context).with(
          'Provider error',
          hash_including(
            monitoring_private_context
          )
        )

        subject
      end

      it 'tracks event as warning, with provider name and error kind' do
        expect(Sentry).to receive(:capture_message).with(
          /#{provider}.*#{error.detail}/,
          hash_including(
            level: 'warning'
          )
        ).at_least(1)

        subject
      end
    end

    describe '#track_deprecated_data' do
      subject { instance.track_deprecated_data(field, deprecated_data) }

      let(:field) { 'category_juridique' }
      let(:deprecated_data) { '7510' }

      it 'tracks event as info, with provider name and field missing' do
        expect(Sentry).to receive(:capture_message).with(
          /#{provider}.*#{field}.*#{deprecated_data}/,
          hash_including(
            level: 'info'
          )
        )

        subject
      end
    end

    describe '#set_retriever_context' do
      subject { instance.set_retriever_context(retriever_context) }

      let(:retriever_context) { Interactor::Context.new(context_data) }
      let(:context_data) { { foo: 'bar' } }

      it 'sets extra context on Sentry' do
        expect(scope).to receive(:set_context).with(
          'Retriever',
          context_data
        )

        subject
      end
    end

    describe '#track' do
      subject { instance.track(level, message, extra_context) }

      let(:level) { 'warning' }
      let(:message) { 'Oops' }
      let(:extra_context) { nil }

      it 'tracks event with level and message' do
        expect(Sentry).to receive(:capture_message).with(
          message,
          {
            level:
          }
        )

        subject
      end

      it 'logs through rails logger with valid level' do
        expect(Rails.logger).to receive(:warn).with(message)

        subject
      end

      context 'with extra_context set' do
        let(:extra_context) do
          {
            lol: 'oki'
          }
        end

        it 'tracks this event on sentry with context' do
          expect(scope).to receive(:set_context).with('Extra context', extra_context)
          expect(Sentry).to receive(:capture_message).with(
            message,
            {
              level:
            }
          )

          subject
        end
      end
    end
  end

  describe 'context setup methods' do
    describe '#set_user_context' do
      subject { instance.set_user_context(user_context) }

      let(:user_uuid) { SecureRandom.uuid }
      let(:jti_uuid) { SecureRandom.uuid }

      let(:user_context) do
        {
          id: user_uuid,
          scopes: %w[scope1 scope2],
          jti: jti_uuid
        }
      end

      it 'sets user context for Sentry' do
        expect(Sentry).to receive(:set_user).with(
          user_context
        )

        subject
      end
    end

    describe '#set_provider' do
      subject { instance.set_provider(provider) }

      let(:provider) { 'dummy' }

      it 'calls Sentry.set_tags with correct attributes' do
        expect(Sentry).to receive(:set_tags).with(
          provider:
        )

        subject
      end
    end

    describe '#set_controller_params' do
      subject { instance.set_controller_params(params) }

      let(:params) do
        {
          'action' => 'show',
          'controller' => 'api/v2/dummy_controller',
          'siren' => valid_siren,
          'token' => 'secret'
        }
      end

      it 'calls scope.set_context without token' do
        expect(scope).to receive(:set_context).with(
          'Controller params',
          { params: params.except('token') }
        )

        subject
      end

      it 'tags context with controller and action' do
        expect(instance).to receive(:set_tags).with(
          endpoint: "#{params['controller']}##{params['action']}"
        )

        subject
      end
    end
  end
end
