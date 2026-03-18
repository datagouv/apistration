class RNAIdFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^W\d[A-Z0-9]\d{7}$/ || value =~ /^0\d{3}0{2}\d{4}$/
      record.errors.add(attribute, :format, message: 'W followed by 9 digits only')
    end
  end
end
