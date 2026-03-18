class MissingMandatoryParamError < UnprocessableEntityError
  attr_reader :field

  def initialize(field)
    @field = field.to_sym
  end

  def code
    {
      context:   '00201',
      object:    '00202',
      recipient: '00203',
    }.fetch(field) do
      raise KeyError, "#{field} is not a valid field name"
    end
  end
end
