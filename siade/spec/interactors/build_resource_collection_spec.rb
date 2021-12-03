RSpec.describe BuildResourceCollection, type: :interactor do
  subject(:call) { dummy_build_class.call(extra_attributes: extra_attributes) }

  let(:dummy_build_class) do
    Class.new(BuildResourceCollection) do
      def resource_collection
        [
          {
            whatever: 'first item'
          }.merge(context.extra_attributes || {}),
          {
            whatever: 'second item'
          }.merge(context.extra_attributes || {})
        ]
      end
    end
  end

  context 'when there is an id defined on the resources' do
    let(:extra_attributes) do
      {
        id: valid_siren
      }
    end

    it 'does not raise an error' do
      expect { call }.not_to raise_error
    end
  end

  context 'when there is no id defined on the resources' do
    let(:extra_attributes) do
      {
        id: nil
      }
    end

    it 'raises an error' do
      expect { call }.to raise_error(BuildResourceCollection::ResourceIdNotDefined)
    end
  end
end
