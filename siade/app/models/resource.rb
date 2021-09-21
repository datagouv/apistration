class Resource
  def initialize(params = {})
    @data = params

    params.each_key do |key|
      self.class.define_method(key) do
        @data[key]
      end

      self.class.define_method("#{key}=") do |new_value|
        @data[key] = new_value
      end
    end
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

  private

  def handle_array_item(item)
    if item.is_a?(String)
      item
    else
      item.to_h
    end
  end
end
