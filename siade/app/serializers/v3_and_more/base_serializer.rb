class V3AndMore::BaseSerializer
  def initialize(model_or_collection, options = {})
    @model_or_collection = model_or_collection
    @is_collection = options.delete(:is_collection)
    @meta = options.delete(:meta)
    @links = options.delete(:links)
  end

  class << self
    attr_accessor :__attributes, :__links, :__meta

    def attributes(*attrs)
      self.__attributes ||= {}

      attrs.each do |attr|
        self.__attributes[attr] = ->(model) { model.public_send(attr) }
      end
    end

    def attribute(attr, &block)
      self.__attributes ||= {}
      self.__attributes[attr] = block
    end

    def link(attr, &block)
      self.__links ||= {}
      self.__links[attr] = block
    end

    def meta(&block)
      self.__meta = block
    end
  end

  def serializable_hash
    if @is_collection
      serialize_collection
    else
      serialize_single_model(@model_or_collection)
    end
  end

  private

  def serialize_collection
    {
      data: @model_or_collection.map { |model| compute_attributes(:__attributes, model).merge(links: compute_attributes(:__links, model)) },
      meta: @meta || {},
      links: @links || {}
    }
  end

  def serialize_single_model(model)
    serialize_model(model).merge({
      meta: self.class.__meta.try(:call, model) || {}
    })
  end

  def serialize_model(model)
    {
      data: compute_attributes(:__attributes, model),
      links: compute_attributes(:__links, model)
    }
  end

  def compute_attributes(kind, model)
    (self.class.public_send(kind) || {}).transform_values do |block|
      block.call(model)
    end
  end
end
