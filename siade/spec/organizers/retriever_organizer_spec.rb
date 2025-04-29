RSpec.describe RetrieverOrganizer, type: :organizer do
  before(:all) do
    class DummyRetrieverInteractor < ApplicationInteractor
      def call # rubocop:disable Metrics/AbcSize
        case context.error_kind
        when :not_found
          context.errors << NotFoundError.new(context.provider_name)
          context.fail!
        when :provider_error
          context.errors << ProviderUnavailable.new(context.provider_name, 'whatever')
          context.fail!
        when :provider_unknown_error
          context.errors << ProviderUnknownError.new(context.provider_name, 'whatever')
          context.fail!
        when :exception
          raise StandardError
        end
      end
    end

    class DummyRetrieverOrganizer < RetrieverOrganizer
      organize DummyRetrieverInteractor

      delegate :provider_name, to: :context
    end
  end

  let(:monitoring_service) { double('monitoring_service', track_provider_error: nil, set_provider: nil) }

  before do
    allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
  end

  describe 'provider_name method' do
    subject { DummyRetrieverOrganizer.call(provider_name:) }

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

      it 'sets provider on monitoring' do
        subject

        expect(monitoring_service).to have_received(:set_provider).with(provider_name)
      end
    end
  end

  describe 'errors tracking' do
    subject { DummyRetrieverOrganizer.call(provider_name:, error_kind:) }

    let(:provider_name) { 'INSEE' }

    before { allow(monitoring_service).to receive(:set_retriever_context) }

    context 'when there is no error' do
      let(:error_kind) { nil }

      it { is_expected.to be_a_success }

      it 'does not track error' do
        subject

        expect(monitoring_service).not_to have_received(:track_provider_error)
      end
    end

    context 'when there is an error' do
      context 'when it is a client error (not found)' do
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

        it 'does not track error' do
          subject

          expect(monitoring_service).not_to have_received(:track_provider_error)
        end
      end

      context 'when it is a provider unknown_error' do
        let(:error_kind) { :provider_unknown_error }

        it { is_expected.to be_a_failure }

        it 'tracks this error' do
          subject

          expect(monitoring_service).to have_received(:track_provider_error).with(
            instance_of(ProviderUnknownError)
          )
        end

        it 'adds the context to tracking' do
          subject

          expect(monitoring_service).to have_received(:set_retriever_context).with(an_instance_of(Interactor::Context))
        end
      end

      context 'when it is an exception' do
        let(:error_kind) { :exception }

        it 'logs the context and raises error' do
          expect { subject }.to raise_error(StandardError)

          expect(monitoring_service).to have_received(:set_retriever_context).with(an_instance_of(Interactor::Context))
        end
      end
    end
  end

  describe 'maintenance' do
    subject(:call_organizer) { DummyRetrieverOrganizer.call(provider_name:) }

    let(:provider_name) { 'INSEE' }
    let(:maintenance_on) { false }

    let(:maintenance_service) { instance_double(MaintenanceService, 'on?' => maintenance_on) }

    before do
      allow(MaintenanceService).to receive(:new).and_return(maintenance_service)
    end

    it 'instanciates MaintenanceService with provider name' do
      call_organizer

      expect(MaintenanceService).to have_received(:new).with(provider_name)
    end

    it 'checks if maintenance is on' do
      call_organizer

      expect(maintenance_service).to have_received(:on?)
    end

    context 'when maintenance is off' do
      it { is_expected.to be_a_success }
    end

    context 'when maintenance is on' do
      let(:maintenance_on) { true }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(MaintenanceError)) }
    end
  end
end
