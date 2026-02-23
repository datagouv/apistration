module ValidatePrenomsFormat
  private

  def valid_prenoms_format?
    param(:prenoms) == [*param(:prenoms)] &&
      !param(:prenoms).empty? &&
      param(:prenoms).none? { |p| String.try_convert(p).nil? }
  end
end
