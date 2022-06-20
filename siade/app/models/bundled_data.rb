class BundledData
  attr_reader :data, :context

  def initialize(data:, context: {})
    @data = data
    @context = context
  end
end
