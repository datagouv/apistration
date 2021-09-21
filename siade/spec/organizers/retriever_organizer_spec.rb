RSpec.describe RetrieverOrganizer, type: :organizer do
  before(:all) do
    class DummyRetrieverInteractor < ApplicationInteractor
      def call
        case context.error_kind
        when :not_found
          context.errors << NotFoundError.new(context.provider_name)
          context.fail!
        when :provider_error
          context.errors << ProviderUnknownError.new(context.provider_name, 'whatever')
          context.fail!
        end
      end
    end

    class DummyRetrieverOrganizer < RetrieverOrganizer
      organize DummyRetrieverInteractor

      delegate :provider_name, to: :context
    end
  end

  describe 'provider_name method' do
    subject { DummyRetrieverOrganizer.call(provider_name: provider_name) }

    context 'when it is not a valid provider name' do
      let(:provider_name) { 'Invalid' }

      it 'raises an error' do
        expect {
          subject
        }.to raise_error(RetrieverOrganizer::InvalidProviderName)
      end
    end

    context 'when it is a valid provider name' do
      let(:provider_name) { 'INSEE' }

      it { is_expected.to be_a_success }

      it 'does not raise an error' do
        expect {
          subject
        }.not_to raise_error
      end
    end
  end

  describe 'errors tracking' do
    subject { DummyRetrieverOrganizer.call(provider_name: provider_name, error_kind: error_kind) }

    let(:provider_name) { 'INSEE' }
    let(:monitoring_service) { double('monitoring_service') }

    before do
      allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
      allow(monitoring_service).to receive(:track_provider_error)
    end

    context 'when there is no error' do
      let(:error_kind) { nil }

      it { is_expected.to be_a_success }

      it 'does not track error' do
        subject

        expect(monitoring_service).not_to have_received(:track_provider_error)
      end
    end

    context 'when there is an error' do
      context 'when it is a not a provider error (not found)' do
        let(:error_kind) { :not_found }

        it { is_expected.to be_a_failure }

        it 'does not track error' do
          subject

          expect(monitoring_service).not_to have_received(:track_provider_error)
        end
      end

      context 'when it is a provider error' do
        let(:error_kind) { :provider_error }

        it { is_expected.to be_a_failure }

        it 'tracks this error' do
          subject

          expect(monitoring_service).to have_received(:track_provider_error).with(
            instance_of(ProviderUnknownError)
          )
        end
      end
    end
  end
end
