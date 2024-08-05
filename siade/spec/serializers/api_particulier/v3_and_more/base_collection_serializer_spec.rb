# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::V3AndMore::BaseCollectionSerializer, type: :serializer do
  subject { serializer.new(dummy_collection, current_user).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes: [], jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }
  let(:dummy_collection) do
    resource_a = Resource.new({
      attr_1: 'attr_1_a',
      attr_2: 'attr_2_a'
    })

    resource_b = Resource.new({
      attr_1: 'attr_1_b',
      attr_2: 'attr_2_b'
    })

    data = [resource_a, resource_b]
    ctx = { meta_1: 'meta_1', link_1: 'link_1' }

    BundledData.new(data:, context: ctx)
  end

  context 'when no serializer is specified for single items' do
    let(:serializer) do
      Class.new(described_class) do
        meta do |ctx|
          {
            example_meta: ctx[:meta_1]
          }
        end
      end
    end

    it 'raises an error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  context 'with a serializer specified for single items' do
    let(:serializer) do
      item_serializer = Class.new(APIParticulier::V3AndMore::BaseSerializer) do
        attributes :attr_1, :attr_2

        attribute :attr_3 do
          data.attr_1 + data.attr_2
        end
      end

      Class.new(described_class) do
        item_serializer item_serializer

        meta do |ctx|
          {
            example_meta: ctx[:meta_1]
          }
        end

        links do |ctx|
          {
            example_url: ctx[:link_1]
          }
        end
      end
    end

    it do
      expect(subject).to eq({
        data: [
          {
            data: {
              attr_1: 'attr_1_a',
              attr_2: 'attr_2_a',
              attr_3: 'attr_1_aattr_2_a'
            },
            meta: {},
            links: {}
          },
          {
            data: {
              attr_1: 'attr_1_b',
              attr_2: 'attr_2_b',
              attr_3: 'attr_1_battr_2_b'
            },
            meta: {},
            links: {}
          }
        ],
        meta: {
          example_meta: 'meta_1'
        },
        links: {
          example_url: 'link_1'
        }
      })
    end
  end
end
