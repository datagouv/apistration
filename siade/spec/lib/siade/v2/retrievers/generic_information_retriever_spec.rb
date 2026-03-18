RSpec.describe SIADE::V2::Retrievers::GenericInformationRetriever do
  let!(:fake_retriever) do
    class FakeDriver < SIADE::V2::Drivers::GenericDriver
      default_to_nil_raw_fetching_methods :info_fail_placeholder

      def initialize(hash)
        @placeholder_to_nil = !!hash.dig(:driver_options, :placeholder_to_nil)
      end

      def provider_name
        'Dummy provider'
      end

      def info_fail_placeholder_raw
        not_an_array['not_a_key']
      end
    end

    class FakeRetriever < SIADE::V2::Retrievers::GenericInformationRetriever
      register_driver :fake_driver, class_name: FakeDriver, init_with: :fake, init_options: :driver_options

      fetch_attributes_through_driver :fake_driver, :info_fail_placeholder

      def provider_name
        'Dummy provider'
      end

      def fake
        'fake'
      end

      def driver_options;end
    end

    FakeRetriever
  end

  # Needed so the default_to_nil rescued call  does not look for a request attribute into fake_driver
  before do
    allow_any_instance_of(SIADE::V2::Drivers::GenericDriver).to receive(:success?).and_return(true)
  end

  context 'when driver fails with placeholder' do
    subject { fake_retriever.new }
    it 'should return the placeholder' do
      allow(subject).to receive(:driver_options).and_return({})
      expect(subject.info_fail_placeholder).to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder))
    end
  end

  context 'when driver fails with no placeholder' do
    subject { fake_retriever.new }
    it 'should return nil instead of placeholder' do
      allow(subject).to receive(:driver_options).and_return({ :placeholder_to_nil => true })
      expect(subject.info_fail_placeholder).to be_nil
    end
  end
end
