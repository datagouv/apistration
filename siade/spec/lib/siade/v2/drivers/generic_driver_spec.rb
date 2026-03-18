RSpec.describe SIADE::V2::Drivers::GenericDriver do
  let(:fake_driver_placeholder) do
    class FakeDriverPlaceholder < SIADE::V2::Drivers::GenericDriver
      default_to_nil_raw_fetching_methods :info_fail_placeholder

      def provider_name
        'Dummy provider'
      end

      def info_fail_placeholder_raw
        not_an_array['not_a_key']
      end
    end

    FakeDriverPlaceholder
  end

  let(:fake_driver_no_placeholder) do
    class FakeDriverNoPlaceholder < SIADE::V2::Drivers::GenericDriver
      default_to_nil_raw_fetching_methods :info_success, :info_fail_no_placeholder

      def initialize
        @placeholder_to_nil = true
      end

      def provider_name
        'Dummy provider'
      end

      def info_success_raw
        'correct_value'
      end

      def info_fail_no_placeholder_raw
        not_an_array['not_a_key']
      end
    end

    FakeDriverNoPlaceholder
  end

  # Needed so the default_to_nil rescued call  does not look for a request attribute into fake_driver*
  before do
    allow_any_instance_of(SIADE::V2::Drivers::GenericDriver).to receive(:success?).and_return(true)
  end

  describe 'Placeholder' do
    subject { fake_driver_no_placeholder.new }

    it 'should return the correct value when driver works correctly and no placeholder is expected' do
      expect(subject.info_success).to eq('correct_value')
    end

    it 'should not return a placeholder (null is OK) when driver fails' do
      expect(subject.info_fail_no_placeholder).to be_nil
    end

    describe 'monitoring' do
      it 'tracks missing data' do
        expect(MonitoringService.instance).to receive(:track_missing_data).with(
          :info_fail_no_placeholder,
          instance_of(NameError),
        )

        subject.info_fail_no_placeholder
      end
    end
  end

  context 'when a placeholder is expected' do
    subject { fake_driver_placeholder.new }
    it 'should return the placeholder' do
      expect(subject.info_fail_placeholder).to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder))
    end
  end
end
