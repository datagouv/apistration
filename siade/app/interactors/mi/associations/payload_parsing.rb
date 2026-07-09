module MI::Associations::PayloadParsing
  private

  def body_as_hash
    context.body_as_hash ||= MI::Associations::PayloadParser.call(body)
  end
end
