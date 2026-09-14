class APIRequestParameter
  attr_reader :name, :required, :location, :options

  def initialize(name:, required: false, location: nil, options: [])
    @name = name
    @required = required
    @location = location
    @options = options
  end

  def label
    input_name
  end

  def input_name
    name.delete_suffix('[]')
  end

  def array?
    name.end_with?('[]')
  end

  def enum?
    options.any?
  end
end
