RSpec.describe RetrieverOrganizer, 'nested', type: :organizer do
  subject(:call_outer) { OuterRetrieverOrganizer.call(nested_fails:, outer_fails:) }

  before(:all) do
    class NestedRetrieverInteractor < ApplicationInteractor
      def call
        return unless context.nested_fails

        context.errors << ProviderUnknownError.new(context.provider_name, 'nested failure')
        context.fail!
      end
    end

    class NestedRetrieverOrganizer < RetrieverOrganizer
      organize NestedRetrieverInteractor

      def provider_name
        'INSEE'
      end
    end

    class OuterRetrieverInteractor < ApplicationInteractor
      def call
        nested = NestedRetrieverOrganizer.call(nested_fails: context.nested_fails)

        fail_with(nested.errors) if nested.failure?
        fail_with([ProviderUnknownError.new(context.provider_name, 'outer failure')]) if context.outer_fails
      end

      private

      def fail_with(errors)
        context.errors.concat(errors)
        context.fail!
      end
    end

    class OuterRetrieverOrganizer < RetrieverOrganizer
      organize OuterRetrieverInteractor

      def provider_name
        'MESRI'
      end
    end
  end

  let(:nested_fails) { false }
  let(:outer_fails) { false }
  let(:tracked_events) { [] }

  after { Sentry.get_current_scope.clear }

  before do
    Sentry.get_current_scope.clear
    allow(Sentry).to receive(:capture_message) do |message, **|
      tracked_events << { message:, provider_tag: Sentry.get_current_scope.tags[:provider] }
    end
  end

  context 'when the outer provider fails after the nested one succeeded' do
    let(:outer_fails) { true }

    it 'reports the error under the outer provider' do
      call_outer

      expect(tracked_events).to eq([{ message: '[MESRI] Error: outer failure', provider_tag: 'MESRI' }])
    end
  end

  context 'when the nested provider fails and the outer one relays its error' do
    let(:nested_fails) { true }

    it 'reports the error once, under the nested provider' do
      call_outer

      expect(tracked_events).to eq([{ message: '[INSEE] Error: nested failure', provider_tag: 'INSEE' }])
    end
  end

  context 'when both providers succeed' do
    it 'leaves the outer provider on the events tracked afterwards' do
      call_outer
      MonitoringService.instance.track_deprecated_data('field', 'value')

      expect(tracked_events.last[:provider_tag]).to eq('MESRI')
    end
  end
end
