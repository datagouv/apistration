class Resource
  def initialize(params = {})
    @data = params.symbolize_keys
  end

  def to_h
    @data.to_h.transform_values do |value|
      case value
      when Resource
        value.to_h
      when Array
        value.map do |item|
          handle_array_item(item)
        end
      else
        value
      end
    end
  end

  def read_attribute_for_serialization(key)
    public_send(key)
  end

  def method_missing(name, *args, &)
    if args.empty? && @data.key?(name.to_sym)
      @data.fetch(name.to_sym)
    else
      super
    end
  end

  def respond_to_missing?(name, *)
    @data.key?(name.to_sym)
  end

  delegate :deep_merge!, to: :@data

  private

  def handle_array_item(item)
    if item.is_a?(String)
      item
    else
      item.to_h
    end
  end
end
