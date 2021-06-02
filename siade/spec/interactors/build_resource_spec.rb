RSpec.describe BuildResource, type: :interactor do
  before(:all) do
    class DummyBuildResource < BuildResource
      def resource_attributes
        {
          whatever: 'oki',
        }.merge(context.extra_attributes || {})
      end
    end
  end

  subject { DummyBuildResource.call(extra_attributes: extra_attributes) }

  context 'when there is an id defined on the resource' do
    let(:extra_attributes) do
      {
        id: valid_siren,
      }
    end

    it 'does not raise an error' do
      expect {
        subject
      }.not_to raise_error
    end
  end

  context 'when there is no id defined on the resource' do
    let(:extra_attributes) do
      {
        id: nil,
      }
    end

    it 'raises an error' do
      expect {
        subject
      }.to raise_error(BuildResource::ResourceIdNotDefined)
    end
  end
end
