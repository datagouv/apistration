# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3AndMore::BaseSerializer, type: :serializer do
  subject { serializer.new(dummy_object).serializable_hash }

  let(:serializer) do
    Class.new(described_class) do
      attributes :attr_1, :attr_2

      attribute :attr_3 do |object|
        object.attr_1 + object.attr_2
      end

      meta do |object|
        {
          example_meta: object.meta_1
        }
      end

      link :example_url, &:url_1
    end
  end

  let(:dummy_object) do
    data = Resource.new({
      attr_1: 'attr_1',
      attr_2: 'attr_2',
      meta_1: 'meta_1',
      url_1: 'url_1'
    })

    BundledData.new(data:)
  end

  it do
    expect(subject).to eq({
      data: {
        attr_1: 'attr_1',
        attr_2: 'attr_2',
        attr_3: 'attr_1attr_2'
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
