class GIPMDS::Effectifs::ValidateDepth < ValidateParamInteractor
  def call
    return if param(:depth).nil?

    return invalid_depth! if param(:depth) == ''
    return invalid_depth! unless valid_integer?
    return invalid_depth! if param(:depth).to_i > 13

    invalid_depth! if param(:depth).to_i.negative?
  end

  private

  def valid_integer?
    !Integer(param(:depth), 10).nil?
  rescue StandardError
    false
  end

  def invalid_depth!
    context.errors << UnprocessableEntityError.new(:gip_mds_depth)
    context.fail!
  end
end
