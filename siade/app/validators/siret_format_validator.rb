class SiretFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_length_and_digits_only(record, attribute, value)
    validate_structure(record, attribute, value)
  end

  def validate_length_and_digits_only(record, attribute, value)
    unless value =~ /\A\d{14}\z/
      record.errors.add(attribute, :format, message: '14 digits only')
    end
  end

  def validate_structure(record, attribute, value)
    unless value!= nil && valid_checksum(value)
      record.errors.add(attribute, :checksum, message: 'must have luhn_checksum ok or be a la poste siret')
    end
  end

  private

  def valid_checksum(value)
    if value =~ /356000000/
      true # SCUMBAG LA POSTE SIRETS
    else
      (luhn_checksum(value) % 10) == 0
    end
  end

  def luhn_checksum(value)
    accum = 0
    value.reverse.each_char.map(&:to_i).each_with_index do |digit, index|
      t = index.even? ? digit : digit * 2
      t = t - 9 if t >= 10
      accum += t
    end
    accum
  end
end
