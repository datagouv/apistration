# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::V3AndMore::BaseSerializer, type: :serializer do
  subject { serializer.new(dummy_object, current_user).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }
  let(:serializer) do
    Class.new(described_class) do
      attributes :attr_1, :attr_2

      attribute :attr_3 do
        data.attr_1 + data.attr_2
      end

      attribute :attr_4, if: -> { scope?(:scope_attr_4) }

      attribute :attr_array do
        data.attr_array.map do |attr|
          {
            hash_value: attr[:attrArrayHashKey]
          }
        end
      end

      meta do |object|
        {
          example_meta: object.meta_1
        }
      end

      link :example_url do
        data.url_1
      end
    end
  end

  let(:dummy_object) do
    data = Resource.new({
      attr_1: 'attr_1',
      attr_2: 'attr_2',
      attr_4: 'attr_4',
      attr_array: [
        { attrArrayHashKey: 'attr_array_1' },
        { attrArrayHashKey: 'attr_array_2' }
      ],
      meta_1: 'meta_1',
      url_1: 'url_1'
    })

    BundledData.new(data:)
  end

  context 'when the scope is not present' do
    let(:scopes) { [] }

    it 'formats data' do
      expect(subject).to eq({
        data: {
          attr_1: 'attr_1',
          attr_2: 'attr_2',
          attr_3: 'attr_1attr_2',
          attr_array: [
            { hash_value: 'attr_array_1' },
            { hash_value: 'attr_array_2' }
          ]
        },
        links: {
          example_url: 'url_1'
        },
        meta: {
          example_meta: 'meta_1'
        }
      })
    end
  end

  context 'when the scope is present' do
    let(:scopes) { %w[scope_attr_4] }

    it 'formats data' do
      expect(subject).to eq({
        data: {
          attr_1: 'attr_1',
          attr_2: 'attr_2',
          attr_3: 'attr_1attr_2',
          attr_array: [
            { hash_value: 'attr_array_1' },
            { hash_value: 'attr_array_2' }
          ],
          attr_4: 'attr_4'
        },
        links: {
          example_url: 'url_1'
        },
        meta: {
          example_meta: 'meta_1'
        }
      })
    end
  end
end
