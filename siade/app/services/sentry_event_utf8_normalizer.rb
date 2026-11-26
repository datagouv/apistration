class SentryEventUtf8Normalizer
  SERIALIZED_ATTRIBUTES = %i[message user tags contexts extra fingerprint transaction].freeze

  def self.call(event)
    SERIALIZED_ATTRIBUTES.each do |attribute|
      event.public_send(:"#{attribute}=", normalize(event.public_send(attribute)))
    end
  end

  def self.normalize(value)
    case value
    when String then normalize_string(value)
    when Hash then value.to_h { |key, nested| [normalize(key), normalize(nested)] }
    when Array then value.map { |nested| normalize(nested) }
    else value
    end
  end

  def self.normalize_string(string)
    case string.encoding
    when Encoding::UTF_8 then string.valid_encoding? ? string : string.scrub
    when Encoding::BINARY then binary_to_utf8(string)
    else transcode(string)
    end
  end

  def self.transcode(string)
    string.encode(Encoding::UTF_8, invalid: :replace, undef: :replace)
  rescue Encoding::ConverterNotFoundError
    string.dup.force_encoding(Encoding::UTF_8).scrub
  end

  def self.binary_to_utf8(string)
    utf8 = string.dup.force_encoding(Encoding::UTF_8)
    return utf8 if utf8.valid_encoding?

    string.encode(Encoding::UTF_8, Encoding::ISO_8859_1)
  end

  private_class_method :normalize, :normalize_string, :transcode, :binary_to_utf8
end
