# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3AndMore::BaseSerializer, type: :serializer do
  subject { DummySerializer.new(dummy_object).serializable_hash }

  before(:all) do
    DummySerializable = Struct.new(:attr_1, :attr_2, :url_1, :meta_1)

    class DummySerializer < V3AndMore::BaseSerializer
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

  let(:dummy_object) { DummySerializable.new('attr_1', 'attr_2', 'url_1', 'meta_1') }

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
