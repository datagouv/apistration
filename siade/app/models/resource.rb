class Resource < OpenStruct
  def to_h
    super.to_h.transform_values do |value|
      if value.is_a?(Resource)
        value.to_h
      elsif value.is_a?(Array)
        value.map do |item|
          if item.is_a?(String)
            item
          else
            item.to_h
          end
        end
      else
        value
      end
    end
  end
end
