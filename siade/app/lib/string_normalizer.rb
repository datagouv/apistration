module StringNormalizer
  extend ActiveSupport::Concern

  ACCENT_MAP = {
    'ÝŸ' => 'Y',
    'ÙÚÛÜ' => 'U',
    'ÒÓÔÕÖØ' => 'O',
    'ÌÍÎÏ' => 'I',
    'ÈÉÊË' => 'E',
    'Ç' => 'C',
    'ÀÁÂÃÄÅ' => 'A',
    'Ð' => 'D',
    'Œ' => 'OE',
    'Æ' => 'AE',
    'Ñ' => 'N'
  }.freeze

  PUNCTUATION_CHARS = '!"#$%&()*+,-./:;<=>?@[\\]^_`{|}~\''.freeze

  private

  def normalize_string(value)
    return nil if value.nil?

    result = uppercase_string(value)
    result = remove_accents(result)
    result = replace_punctuation_with_spaces(result)
    result = filter_ascii_range(result)
    result = prevent_consecutive_spaces(result)
    trim_whitespace(result)
  end

  def uppercase_string(value)
    value.to_s.upcase
  end

  def remove_accents(value)
    ACCENT_MAP.reduce(value) do |result, (accented_chars, replacement)|
      result.tr(accented_chars, replacement)
    end
  end

  def replace_punctuation_with_spaces(value)
    value.tr(PUNCTUATION_CHARS, ' ')
  end

  def filter_ascii_range(value)
    value.gsub(/[^\x20-\x7E]/, '')
  end

  def prevent_consecutive_spaces(value)
    value.squeeze(' ')
  end

  def trim_whitespace(value)
    value&.strip
  end
end
