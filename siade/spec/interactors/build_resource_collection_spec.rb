RSpec.describe BuildResourceCollection do
  subject { build_resource_collection.call }

  context 'when items is not specified' do
    let(:build_resource_collection) do
      Class.new(described_class) do
        def not_items
          %i[item_1 item_2]
        end
      end
    end

    it 'raises an error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  context 'when items are specified' do
    context 'when no resource attributes are specified' do
      let(:build_resource_collection) do
        Class.new(described_class) do
          def items
            [
              {
                much_attr: :much_attr_1,
                very_attr: :very_attr_1
              },
              {
                much_attr: :much_attr_2,
                very_attr: :very_attr_2
              }
            ]
          end

          def not_resource_attributes(item)
            {
              resource_much_attr: item[:much_attr]
            }
          end
        end
      end

      it 'raises an error' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when resource attributes are specified' do
      context 'when context data are specified' do
        let(:build_resource_collection) do
          Class.new(described_class) do
            def items
              [
                {
                  much_attr: :much_attr_1,
                  very_attr: :very_attr_1
                },
                {
                  much_attr: :much_attr_2,
                  very_attr: :very_attr_2
                }
              ]
            end

            def resource_attributes(item)
              {
                resource_much_attr: item[:much_attr],
                resource_very_attr: item[:very_attr]
              }
            end

            def items_context
              {
                meta: :data
              }
            end
          end
        end

        it { is_expected.to be_a_success }

        it 'feeds BundledData with the resources collection' do
          resource_collection = subject.bundled_data.data

          expect(resource_collection).to all(be_a(Resource))

          expect(resource_collection.map(&:to_h)).to eq([
            {
              resource_much_attr: :much_attr_1,
              resource_very_attr: :very_attr_1
            },
            {
              resource_much_attr: :much_attr_2,
              resource_very_attr: :very_attr_2
            }
          ])
        end

        it 'feeds BundledData with the context data' do
          context = subject.bundled_data.context

          expect(context).to eq({ meta: :data })
        end
      end

      context 'when no context data are specified' do
        let(:build_resource_collection) do
          Class.new(described_class) do
            def items
              [
                {
                  much_attr: :much_attr_1,
                  very_attr: :very_attr_1
                },
                {
                  much_attr: :much_attr_2,
                  very_attr: :very_attr_2
                }
              ]
            end

            def resource_attributes(item)
              {
                resource_much_attr: item[:much_attr],
                resource_very_attr: item[:very_attr]
              }
            end
          end
        end

        it { is_expected.to be_a_success }

        it 'feeds BundledData with the resources collection' do
          resource_collection = subject.bundled_data.data

          expect(resource_collection).to all(be_a(Resource))

          expect(resource_collection.map(&:to_h)).to eq([
            {
              resource_much_attr: :much_attr_1,
              resource_very_attr: :very_attr_1
            },
            {
              resource_much_attr: :much_attr_2,
              resource_very_attr: :very_attr_2
            }
          ])
        end

        it 'feeds BundledData with empty context data' do
          context = subject.bundled_data.context

          expect(context).to be_empty
        end
      end
    end
  end
end
