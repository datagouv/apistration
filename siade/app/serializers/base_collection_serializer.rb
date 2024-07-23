class BaseCollectionSerializer < BaseSerializer
  class << self
    attr_accessor :__item_serializer

    def item_serializer(serializer = nil, &block)
      self.__item_serializer = serializer || block
    end

    def links(&block)
      self.__links = block
    end

    def meta(&block)
      self.__meta = block
    end
  end

  def serializable_hash
    serialize_collection
  end

  private

  def serialize_collection
    {
      data: data.map { |item| serialize_item(item) },
      meta: serialize_meta,
      links: serialize_links
    }
  end

  def serialize_item(item)
    bundled_data = BundledData.new(data: item)

    single_item_serializer(item).new(bundled_data).serializable_hash
  end

  def single_item_serializer(item)
    return serializer unless serializer.is_a?(Proc)

    serializer.call(item)
  end

  def serializer
    self.class.__item_serializer || fail(NotImplementedError)
  end

  def serialize_meta
    self.class.__meta.try(:call, context) || {}
  end

  def serialize_links
    self.class.__links.try(:call, context) || {}
  end
end
