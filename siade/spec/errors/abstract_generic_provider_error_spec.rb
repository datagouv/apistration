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

  describe '#add_meta' do
    subject { DummyAbstractGenericProviderError.new('INSEE').add_meta(extra_meta).to_h }

    let(:extra_meta) do
      {
        oki: 'lol',
      }
    end

    it 'adds this meta to final payload' do
      expect(subject[:meta]).to eq(
        {
          provider: 'INSEE',
        }.merge(extra_meta)
      )
    end
  end
end
