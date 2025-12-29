class BaseSerializer
  attr_reader :data, :context, :current_user

  def initialize(payload_data, current_user)
    @data = payload_data.data
    @context = payload_data.context
    @current_user = current_user
  end

  class << self
    attr_accessor :__attributes, :__links, :__meta

    def attributes(*attrs)
      self.__attributes ||= {}

      attrs.each do |attr|
        self.__attributes[attr] = {
          block: -> { data.public_send(attr) },
          if: nil
        }
      end
    end

    def attribute(attr, options = {}, &block)
      self.__attributes ||= {}
      self.__attributes[attr] = {
        block: block || -> { data.public_send(attr) },
        if: options[:if]
      }
    end

    def link(attr, options = {}, &block)
      self.__links ||= {}
      self.__links[attr] = {
        block: block || -> { data.public_send(attr) },
        if: options[:if]
      }
    end

    def meta(&block)
      self.__meta = block
    end
  end

  def serializable_hash
    serialize_single_resource
  end

  protected

  def scope?(scope_name)
    current_user.scope?(scope_name.to_s)
  end

  def one_of_scopes?(scopes)
    scopes.any? { |scope| scope?(scope) }
  end

  private

  def serialize_single_resource
    serialize_model(data)
  end

  def serialize_model(model)
    {
      data: compute_attributes(:__attributes, model),
      links: compute_attributes(:__links, model),
      meta: inherited_meta&.call(model) || {}
    }
  end

  def inherited_meta
    klass = self.class
    while klass.respond_to?(:__meta)
      return klass.__meta if klass.__meta

      klass = klass.superclass
    end
    nil
  end

  def compute_attributes(kind, model)
    (filtered_attributes(kind, model) || {}).transform_values do |blocks|
      instance_exec(&blocks[:block])
    end
  end

  def filtered_attributes(kind, _model)
    inherited_attrs(kind).select do |_attr, blocks|
      blocks[:if].nil? || instance_exec(&blocks[:if])
    end
  end

  def inherited_attrs(kind)
    result = {}
    klass = self.class
    while klass.respond_to?(kind)
      attrs = klass.public_send(kind)
      result = attrs.merge(result) if attrs
      klass = klass.superclass
    end
    result
  end
end
