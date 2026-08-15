class RNFIdFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A\d{2,3}[AB]?-(FRUP|FDD|FE)-\d{5}-\d{2}\z/i

    record.errors.add(attribute, :format, message: 'department code, foundation type (FRUP, FDD or FE), 5 digits and 2 digits, separated by dashes')
  end
end
