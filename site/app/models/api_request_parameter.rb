class APIRequestParameter
  attr_reader :name, :required, :location, :options

  def initialize(name:, required: false, location: nil, options: [])
    @name = name
    @required = required
    @location = location
    @options = options
  end

  def label
    name.delete_suffix('[]')
  end

  def input_name
    header? ? "headers[#{name}]" : label
  end

  def value_from(params)
    header? ? params.dig(:headers, name) : params[input_name]
  end

  def array?
    name.end_with?('[]')
  end

  def enum?
    options.any?
  end

  def header?
    location == 'header'
  end
end
