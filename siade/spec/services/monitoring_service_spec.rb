RSpec.describe MonitoringService, type: :service do
  let(:instance) { MonitoringService.instance }
  let(:provider) { 'dummy' }

  describe 'tracking methods' do
    before do
      instance.set_provider(provider)
    end

    after do
      Sentry.get_current_scope.clear
    end

    describe '#track_provider_error' do
      subject { instance.track_provider_error(error) }

      let(:error) { ProviderInternalServerError.new('INSEE', 'PANIK') }
      let(:private_context) do
        {
          oauth_token: 'very_secret',
        }
      end

      before do
        error.add_private_context(private_context)
      end

      it 'sets extra context with error payload, which returns json api error with all available informations' do
        expect(Sentry).to receive(:set_extras).with(
          hash_including(
            error.to_h,
          )
        )

        subject
      end

      it 'sets extra context with private context, which is not returned to users' do
        expect(Sentry).to receive(:set_extras).with(
          hash_including(
            private_context,
          )
        )

        subject
      end

      it 'tracks event as warning, with provider name and error kind' do
        expect(Sentry).to receive(:capture_message).with(
          /#{provider}.*#{error.detail}/,
          hash_including(
            level: 'warning',
          )
        ).at_least(1)

        subject
      end
    end

    describe '#track_provider_error_from_response' do
      before(:all) do
        class SIADE::V2::Responses::DummyTrackProviderErrorResponse < SIADE::V2::Responses::Generic
          def adapt_raw_response_code
            errors << OldTokenError.new

            @provider_error_custom_code = raw_response.provider_error_custom_code

            raw_response.code
          end
        end
      end

      subject { instance.track_provider_error_from_response(response, extra_context) }

      let(:raw_response) do
        OpenStruct.new(
          body: '',
          code: code,
          provider_error_custom_code: provider_error_custom_code,
        )
      end
      let(:extra_context) do
        {
          custom_message: 'PANIK',
        }
      end

      let(:provider_error_custom_code) { '9001' }
      let(:code) { 367 }
      let(:response) { SIADE::V2::Responses::DummyTrackProviderErrorResponse.new(raw_response) }

      it 'sets extra context with errors inspected (which returns json api error with all available informations)' do
        expect(Sentry).to receive(:set_extras).with(
          hash_including(
            errors: response.errors.map(&:to_h),
          )
        )

        subject
      end

      it 'sets extra context with extra_context param' do
        expect(Sentry).to receive(:set_extras).with(
          hash_including(
            extra_context,
          )
        )

        subject
      end

      it 'sets tag provider_error_code with response#provider_error_custom_code' do
        expect(Sentry).to receive(:set_tags).with(
          provider_error_code: provider_error_custom_code,
        )

        subject
      end

      describe 'provider_error_custom_code' do
        context 'when it is not defined' do
          let(:provider_error_custom_code) { nil }

          it 'takes http code for tagging' do
            expect(Sentry).to receive(:set_tags).with(
              provider_error_code: code,
            )

            subject
          end
        end
      end

      it 'tracks event as warning, with provider name and error kind' do
        expect(Sentry).to receive(:capture_message).with(
          /#{provider}.*DummyTrackProviderErrorResponse/,
          hash_including(
            level: 'warning',
          )
        ).at_least(1)

        subject
      end
    end

    describe '#track_missing_data' do
      subject { instance.track_missing_data(field, exception) }

      let(:field) { 'adresse' }
      let(:exception) do
        begin
          nil.lol?
        rescue => e
          e
        end
      end

      it 'tracks event as info, with provider name and field missing' do
        expect(Sentry).to receive(:capture_message).with(
          /#{provider}.*#{field}/,
          hash_including(
            level: 'info',
          )
        )

        subject
      end

      it 'sets context with exception' do
        expect(Sentry).to receive(:set_extras).with(
          exception: exception.message,
          backtrace: exception.backtrace,
        )

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
            level: 'info',
          )
        )

        subject
      end
    end

    describe "#track" do
      subject { instance.track(level, message, extra_context) }

      let(:level) { 'warning' }
      let(:message) { 'Oops' }
      let(:extra_context) { nil }

      it 'tracks event with level and message' do
        expect(Sentry).to receive(:capture_message).with(
          message,
          {
            level: level,
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
            lol: 'oki',
          }
        end

        it 'tracks this event on sentry with context' do
          expect(Sentry).to receive(:set_extras).with(extra_context)
          expect(Sentry).to receive(:capture_message).with(
            message,
            {
              level: level,
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
          roles: ['role1', 'role2'],
          jti: jti_uuid,
        }
      end

      it 'sets user context for Sentry' do
        expect(Sentry).to receive(:set_user).with(
          user_context,
        )

        subject
      end
    end

    describe '#set_provider' do
      subject { instance.set_provider(provider) }

      let(:provider) { 'dummy' }

      it 'calls Sentry.set_tags with correct attributes' do
        expect(Sentry).to receive(:set_tags).with(
          provider: provider,
        )

        subject
      end
    end

    describe '#set_controller_params' do
      subject { instance.set_controller_params(params) }

      let(:params) do
        {
          'action'      => 'show',
          'controller'  => 'api/v2/dummy_controller',
          'siren'       => valid_siren,
          'token'       => 'secret',
        }
      end

      it 'calls Sentry.set_extras without token' do
        expect(Sentry).to receive(:set_extras).with(
          params: params.except('token'),
        )

        subject
      end

      it 'tags context with controller and action' do
        expect(instance).to receive(:set_tags).with(
          endpoint: "#{params['controller']}##{params['action']}",
        )

        subject
      end
    end
  end
end
