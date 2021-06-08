RSpec.describe AbstractGenericProviderError, type: :error do
  before(:all) do
    class DummyAbstractGenericProviderError < AbstractGenericProviderError
      def subcode
        '000'
      end
    end
  end

  it_behaves_like 'a valid error' do
    let(:instance) { DummyAbstractGenericProviderError.new('INSEE', 'whatever') }
  end
end
