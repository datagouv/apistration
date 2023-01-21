RSpec.describe BuildResource do
  subject { build_resource.call(mocked_data:) }

  let(:mocked_data) { nil }

  context 'when no resource attributes are specified' do
    let(:build_resource) do
      Class.new(described_class) do
        def not_resource_attributes
          {
            dodo: :dommage
          }
        end
      end
    end

    context 'when it is staging' do
      before do
        allow(Rails).to receive(:env).and_return('staging'.inquiry)
      end

      it 'does not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when it is not staging' do
      it 'raises an error' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  context 'when resource attributes are specified' do
    let(:build_resource) do
      Class.new(described_class) do
        def resource_attributes
          {
            attr: :very_data
          }
        end
      end
    end

    it { is_expected.to be_a_success }

    it 'feeds BundledData with the resource object' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)

      expect(resource.attr).to eq(:very_data)
    end

    it 'sets an empty context for the BundledData' do
      expect(subject.bundled_data.context).to be_empty
    end
  end
end
