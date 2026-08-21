module ValidatePrenomsFormat
  FORBIDDEN_CHARACTERS_REGEX = /[,()\[\]{}]/

  private

  def valid_prenoms_format?
    param(:prenoms) == [*param(:prenoms)] &&
      !param(:prenoms).empty? &&
      param(:prenoms).none? { |p| String.try_convert(p).nil? } &&
      param(:prenoms).none? { |p| p.match?(FORBIDDEN_CHARACTERS_REGEX) }
  end
end
